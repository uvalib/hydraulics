# Methods common to models that have a :pid attribute.
module Pidable
  extend ActiveSupport::Concern

  require 'rubydora'

  included do
    belongs_to :availability_policy, :counter_cache => true
    belongs_to :indexing_scenario, :counter_cache => true
    belongs_to :use_right, :counter_cache => true

    has_and_belongs_to_many :legacy_identifiers

    validates :availability_policy, :presence => {
      :if => 'availability_policy_id',
      :message => "association with this AvailabilityPolicy is no longer valid because it no longer exists."
    }
    validates :indexing_scenario, :presence => {
      :if => 'indexing_scenario_id',
      :message => "association with this IndexingScenario is no longer valid because it no longer exists."
    }

    scope :in_digital_library, where("date_dl_ingest is not null").order("date_dl_ingest ASC")
    scope :not_in_digital_library, where("date_dl_ingest is null")

    before_save :assign_pid
  end

  def assign_pid
    self.pid = get_pid if self.pid.nil?
  end

  # Query Fedora to get next pid
  def get_pid(pid_namespace = nil)
    # Determine proper namespace
    # Rails.env == 'production' ?  pid_namespace = 'uva-lib' : pid_namespace = 'test'

    repo = Rubydora.connect :url => 'http://localhost:8080/fedora', :user => 'fedoraAdmin', :password => 'fedoraAdmin'
    xml = Nokogiri.XML(repo.next_pid({:namespace => pid_namespace }))
    xml.remove_namespaces!
    xml.xpath('//pid').first.content
  end

  def in_dl?
    date_dl_ingest?
  end






  # require 'solr'

  # require 'activemessaging/processor'
  # include ActiveMessaging::MessageSender

  # Returns a boolean indicating whether a datastream for a piddable object exists in the Fedora repo
  def datastream_exists?(dsID)
    # Set up REST client
    resource = RestClient::Resource.new FEDORA_REST_URL, :user => Fedora_username, :password => Fedora_password

    url = "/objects/#{self.pid}/datastreams/#{dsID}?format=xml"
    begin
      response = resource[url].get
    rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout
      return false
    end
    return true
  end

  # Query a given Solr index to determine if object's index record is found there.  A default Solr index is used if none is provided at method invocation.
  def exists_in_index?(solr_url = nil)
    solr_url = STAGING_SOLR_URL if solr_url.nil?
    if pid.nil?
      return false
    else
      @solr_connection = Solr::Connection.new("#{solr_url}", :autocommit => :off)

      begin
        hits = @solr_connection.query("id:#{pid.gsub(/:/, '?')}").hits
      rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout
        return false
      end

      return true unless hits.length != 1
    end
  end

  # Returns a boolean indicating whether an object with the same PID as this one exists in the Fedora repo
  def exists_in_repo?
    if pid.nil?
      return false
    else
      # Determine whether this object exists (using Fedora API findObjects, which uses HTTP GET)
      # * If Fedora finds the object, no exception occurs
      # * If Fedora can't find the object, RestClient::ResourceNotFound exception occurs
      # * If any other exception occurs, it remains unhandled and gets raised
      resource = RestClient::Resource.new FEDORA_REST_URL, :user => Fedora_username, :password => Fedora_password
      url = "/objects?query=pid%3D#{pid}&resultFormat=xml&pid=true"

      begin
        response = resource[url].get
      rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout
        return false
      end
      return response.include? "#{pid}"
    end
  end

  def remove_from_repo
    if pid.nil?
      return false
    else
      resource = RestClient::Resource.new FEDORA_REST_URL, :user => Fedora_username, :password => Fedora_password
      url = "/objects/#{pid}"

      begin
        response = resource[url].delete
      rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout
        return false
      end
      return response.include? "#{Time.now.strftime('%Y-%m-%d')}"
    end
  end

  def remove_from_index(solr_url = nil)
    solr_url = STAGING_SOLR_URL if solr_url.nil?
    if pid.nil?
      return false
    else
      @solr_connection = Solr::Connection.new("#{solr_url}", :autocommit => :off)

      begin
        @solr_connection.delete(pid)
      rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout
        return false
      end
      return true
    end

  end

  # Methods for ingest and Fedora management workflows
  def update_metadata(datastream)
    message = ActiveSupport::JSON.encode( { :object_class => self.class.to_s, :object_id => self.id, :datastream => datastream })
    publish :update_fedora_datastreams, message
    # flash[:notice] = "#{params[:datastream].gsub(/_/, ' ').capitalize} datastream(s) being updated."
    # redirect_to :action => "show", :controller => "bibl", :id => params[:object_id]
  end
end
