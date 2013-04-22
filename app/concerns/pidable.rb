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

  @@repo = Rubydora.connect :url => 'http://localhost:8080/fedora', :user => 'fedoraAdmin', :password => 'fedoraAdmin'

  def assign_pid
    self.pid = get_pid if self.pid.nil?
  end

  # Query Fedora to get next pid
  def get_pid(pid_namespace = nil)
    xml = Nokogiri.XML(@@repo.next_pid({:namespace => pid_namespace }))
    xml.remove_namespaces!
    xml.xpath('//pid[1]').text
  end

  def in_dl?
    date_dl_ingest?
  end

  # Returns a boolean indicating whether an object with the same PID as this one exists in the Fedora repo
  def exists_in_repo?
    if self.pid?
      begin
        @@repo.find("#{self.pid}").is_a?(Rubydora::DigitalObject)
      rescue Rubydora::RecordNotFound
        return false
      end
    end
  end

  def remove_from_repo
    if self.pid?
      begin
        @@repo.purge_object pid: :self.pid
      rescue Rubydora::RecordNotFound
        return false
      end
    end
  end


##########

  # # Returns a boolean indicating whether a datastream for a piddable object exists in the Fedora repo
  # def datastream_exists?(dsID)
  #   url = "/objects/#{self.pid}/datastreams/#{dsID}?format=xml"
  #   begin
  #     response = resource[url].get
  #   rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout
  #     return false
  #   end
  #   return true
  # end

  # require 'solr'
  # # Query a given Solr index to determine if object's index record is found there.  A default Solr index is used if none is provided at method invocation.
  # def exists_in_index?(solr_url = nil)
  #   solr_url = STAGING_SOLR_URL if solr_url.nil?
  #   if pid.nil?
  #     return false
  #   else
  #     @solr_connection = Solr::Connection.new("#{solr_url}", :autocommit => :off)

  #     begin
  #       hits = @solr_connection.query("id:#{pid.gsub(/:/, '?')}").hits
  #     rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout
  #       return false
  #     end

  #     return true unless hits.length != 1
  #   end
  # end


  # def remove_from_index(solr_url = nil)
  #   solr_url = STAGING_SOLR_URL if solr_url.nil?
  #   if pid.nil?
  #     return false
  #   else
  #     @solr_connection = Solr::Connection.new("#{solr_url}", :autocommit => :off)

  #     begin
  #       @solr_connection.delete(pid)
  #     rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout
  #       return false
  #     end
  #     return true
  #   end

  # end
end
