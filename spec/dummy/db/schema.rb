# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 29) do

  create_table "academic_statuses", :force => true do |t|
    t.string   "name"
    t.integer  "customers_count", :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "academic_statuses", ["name"], :name => "index_academic_statuses_on_name", :unique => true

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id",                 :null => false
    t.string   "addressable_type", :limit => 20, :null => false
    t.string   "address_type",     :limit => 20, :null => false
    t.string   "last_name"
    t.string   "first_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "post_code"
    t.string   "phone"
    t.string   "organization"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "agencies", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_billable",       :default => false, :null => false
    t.string   "last_name"
    t.string   "first_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "post_code"
    t.string   "phone"
    t.string   "ancestry"
    t.string   "names_depth_cache"
    t.integer  "orders_count",      :default => 0
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "agencies", ["ancestry"], :name => "index_agencies_on_ancestry"
  add_index "agencies", ["name"], :name => "index_agencies_on_name", :unique => true

  create_table "archives", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "units_count", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "archives", ["name"], :name => "index_archives_on_name", :unique => true

  create_table "automation_messages", :force => true do |t|
    t.integer  "messagable_id",                                    :null => false
    t.integer  "messagable_type", :limit => 20,                    :null => false
    t.boolean  "active_error",                  :default => false, :null => false
    t.string   "app",             :limit => 20
    t.string   "processor",       :limit => 50
    t.string   "message_type",    :limit => 20
    t.string   "message"
    t.string   "class_name",      :limit => 50
    t.text     "backtrace"
    t.string   "workflow_type",   :limit => 20
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "automation_messages", ["active_error"], :name => "index_automation_messages_on_active_error"
  add_index "automation_messages", ["messagable_id", "messagable_type"], :name => "index_automation_messages_on_messagable_id_and_messagable_type"
  add_index "automation_messages", ["message_type"], :name => "index_automation_messages_on_message_type"
  add_index "automation_messages", ["processor"], :name => "index_automation_messages_on_processor"
  add_index "automation_messages", ["workflow_type"], :name => "index_automation_messages_on_workflow_type"

  create_table "availability_policies", :force => true do |t|
    t.string   "name"
    t.string   "xacml_policy_url"
    t.integer  "bibls_count",        :default => 0
    t.integer  "components_count",   :default => 0
    t.integer  "master_files_count", :default => 0
    t.integer  "units_count",        :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "bibls", :force => true do |t|
    t.integer  "indexing_scenario_id"
    t.integer  "availability_policy_id"
    t.integer  "use_right_id"
    t.integer  "parent_bibl_id",                                :default => 0,     :null => false
    t.datetime "date_external_update"
    t.string   "description"
    t.boolean  "is_approved",                                   :default => false, :null => false
    t.boolean  "is_collection",                                 :default => false, :null => false
    t.boolean  "is_in_catalog",                                 :default => false, :null => false
    t.boolean  "is_manuscript",                                 :default => false, :null => false
    t.boolean  "is_personal_item",                              :default => false, :null => false
    t.string   "barcode"
    t.string   "call_number"
    t.string   "catalog_key"
    t.text     "citation"
    t.integer  "copy"
    t.string   "creator_name"
    t.string   "creator_name_type"
    t.string   "genre"
    t.string   "issue"
    t.string   "location"
    t.string   "resource_type"
    t.string   "series_title"
    t.string   "title"
    t.string   "title_control"
    t.string   "volume"
    t.string   "year"
    t.string   "year_type"
    t.text     "dc"
    t.text     "desc_metadata"
    t.boolean  "discoverability",                               :default => true
    t.string   "exemplar"
    t.string   "pid"
    t.text     "rels_ext"
    t.text     "rels_int"
    t.text     "solr",                      :limit => 16777215
    t.datetime "date_dl_ingest"
    t.integer  "automation_messages_count",                     :default => 0
    t.integer  "orders_count",                                  :default => 0
    t.integer  "units_count",                                   :default => 0
    t.integer  "master_files_count",                            :default => 0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "bibls", ["availability_policy_id"], :name => "index_bibls_on_availability_policy_id"
  add_index "bibls", ["barcode"], :name => "index_bibls_on_barcode"
  add_index "bibls", ["call_number"], :name => "index_bibls_on_call_number"
  add_index "bibls", ["catalog_key"], :name => "index_bibls_on_catalog_key"
  add_index "bibls", ["indexing_scenario_id"], :name => "index_bibls_on_indexing_scenario_id"
  add_index "bibls", ["parent_bibl_id"], :name => "index_bibls_on_parent_bibl_id"
  add_index "bibls", ["pid"], :name => "index_bibls_on_pid"
  add_index "bibls", ["title"], :name => "index_bibls_on_title"
  add_index "bibls", ["use_right_id"], :name => "index_bibls_on_use_right_id"

  create_table "bibls_components", :force => true do |t|
    t.integer "bibl_id"
    t.integer "component_id"
  end

  add_index "bibls_components", ["bibl_id"], :name => "index_bibls_components_on_bibl_id"
  add_index "bibls_components", ["component_id"], :name => "index_bibls_components_on_component_id"

  create_table "bibls_legacy_identifiers", :id => false, :force => true do |t|
    t.integer "bibl_id"
    t.integer "legacy_identifier_id"
  end

  add_index "bibls_legacy_identifiers", ["bibl_id"], :name => "index_bibls_legacy_identifiers_on_bibl_id"
  add_index "bibls_legacy_identifiers", ["legacy_identifier_id"], :name => "index_bibls_legacy_identifiers_on_legacy_identifier_id"

  create_table "checkins", :force => true do |t|
    t.integer  "unit_id"
    t.integer  "admin_user_id"
    t.integer  "units_count",   :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "component_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "component_types", ["name"], :name => "index_component_types_on_name", :unique => true

  create_table "components", :force => true do |t|
    t.integer  "availability_policy_id"
    t.integer  "component_type_id"
    t.integer  "indexing_scenario_id"
    t.integer  "use_right_id"
    t.integer  "parent_component_id"
    t.string   "title"
    t.text     "content_desc"
    t.string   "date"
    t.boolean  "discoverability",                               :default => true
    t.string   "exemplar"
    t.string   "pid"
    t.text     "dc"
    t.text     "desc_metadata"
    t.text     "rels_ext"
    t.text     "rels_int"
    t.text     "solr",                      :limit => 16777215
    t.datetime "date_dl_ingest"
    t.datetime "date_dl_update"
    t.integer  "master_files_count",                            :default => 0
    t.integer  "automation_messages_count",                     :default => 0
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  add_index "components", ["availability_policy_id"], :name => "index_components_on_availability_policy_id"
  add_index "components", ["component_type_id"], :name => "index_components_on_component_type_id"
  add_index "components", ["indexing_scenario_id"], :name => "index_components_on_indexing_scenario_id"
  add_index "components", ["use_right_id"], :name => "index_components_on_use_right_id"

  create_table "components_containers", :force => true do |t|
    t.integer "component_id"
    t.integer "container_id"
  end

  add_index "components_containers", ["component_id"], :name => "index_components_containers_on_component_id"
  add_index "components_containers", ["container_id"], :name => "index_components_containers_on_container_id"

  create_table "components_legacy_identifiers", :id => false, :force => true do |t|
    t.integer "component_id"
    t.integer "legacy_identifier_id"
  end

  add_index "components_legacy_identifiers", ["component_id"], :name => "index_components_legacy_identifiers_on_component_id"
  add_index "components_legacy_identifiers", ["legacy_identifier_id"], :name => "index_components_legacy_identifiers_on_legacy_identifier_id"

  create_table "container_types", :force => true do |t|
    t.string "name"
    t.string "description"
  end

  add_index "container_types", ["name"], :name => "index_container_types_on_name", :unique => true

  create_table "containers", :force => true do |t|
    t.string   "barcode"
    t.integer  "container_type_id"
    t.string   "label"
    t.string   "sequence_no"
    t.integer  "parent_container_id", :default => 0, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "containers", ["container_type_id"], :name => "index_containers_on_container_type_id"
  add_index "containers", ["parent_container_id"], :name => "index_containers_on_parent_container_id"

  create_table "customers", :force => true do |t|
    t.integer  "department_id"
    t.integer  "academic_status_id"
    t.integer  "heard_about_service_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "email"
    t.string   "organization"
    t.integer  "orders_count",           :default => 0
    t.integer  "master_files_count",     :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "customers", ["academic_status_id"], :name => "index_customers_on_academic_status_id"
  add_index "customers", ["department_id"], :name => "index_customers_on_department_id"
  add_index "customers", ["email"], :name => "index_customers_on_email"
  add_index "customers", ["first_name"], :name => "index_customers_on_first_name"
  add_index "customers", ["heard_about_service_id"], :name => "index_customers_on_heard_about_service_id"
  add_index "customers", ["last_name"], :name => "index_customers_on_last_name"

  create_table "delivery_methods", :force => true do |t|
    t.string   "label"
    t.string   "description"
    t.boolean  "is_internal_use_only", :default => false, :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "delivery_methods", ["label"], :name => "index_delivery_methods_on_label", :unique => true

  create_table "delivery_methods_orders", :id => false, :force => true do |t|
    t.integer "delivery_method_id"
    t.integer "order_id"
  end

  add_index "delivery_methods_orders", ["delivery_method_id"], :name => "index_delivery_methods_orders_on_delivery_method_id"
  add_index "delivery_methods_orders", ["order_id"], :name => "index_delivery_methods_orders_on_order_id"

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "customers_count", :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "departments", ["name"], :name => "index_departments_on_name", :unique => true

  create_table "dvd_delivery_locations", :force => true do |t|
    t.string   "name"
    t.text     "email_desc"
    t.integer  "orders_count", :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "dvd_delivery_locations", ["name"], :name => "index_dvd_delivery_locations_on_name", :unique => true

  create_table "heard_about_resources", :force => true do |t|
    t.string   "description"
    t.boolean  "is_approved",          :default => false, :null => false
    t.boolean  "is_internal_use_only", :default => false, :null => false
    t.integer  "units_count",          :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "heard_about_resources", ["description"], :name => "index_heard_about_resources_on_description"

  create_table "heard_about_services", :force => true do |t|
    t.string   "description"
    t.boolean  "is_approved",          :default => false, :null => false
    t.boolean  "is_internal_use_only", :default => false, :null => false
    t.integer  "customers_count",      :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "heard_about_services", ["description"], :name => "index_heard_about_services_on_description"

  create_table "image_tech_meta", :force => true do |t|
    t.integer  "master_file_id", :default => 0, :null => false
    t.string   "image_format"
    t.integer  "width"
    t.integer  "height"
    t.integer  "resolution"
    t.string   "color_space"
    t.integer  "depth"
    t.string   "compression"
    t.string   "color_profile"
    t.string   "equipment"
    t.string   "software"
    t.string   "model"
    t.string   "exif_version"
    t.datetime "capture_date"
    t.integer  "iso"
    t.string   "exposure_bias"
    t.string   "exposure_time"
    t.string   "aperture"
    t.decimal  "focal_length"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "image_tech_meta", ["master_file_id"], :name => "index_image_tech_meta_on_master_file_id"

  create_table "indexing_scenarios", :force => true do |t|
    t.string   "name"
    t.string   "pid"
    t.string   "datastream_name"
    t.string   "repository_url"
    t.integer  "bibls_count",        :default => 0
    t.integer  "components_count",   :default => 0
    t.integer  "master_files_count", :default => 0
    t.integer  "units_count",        :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "intended_uses", :force => true do |t|
    t.string   "description"
    t.string   "deliverable_format"
    t.string   "deliverable_resolution"
    t.string   "deliverable_resolution_unit"
    t.boolean  "is_internal_use_only",        :default => false, :null => false
    t.boolean  "is_approved",                 :default => false, :null => false
    t.integer  "units_count",                 :default => 0
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "intended_uses", ["description"], :name => "index_intended_uses_on_description", :unique => true

  create_table "invoices", :force => true do |t|
    t.integer  "order_id",                                    :default => 0,     :null => false
    t.datetime "date_invoice_sent"
    t.decimal  "fee_amount_paid"
    t.datetime "date_second_invoice_sent"
    t.text     "notes"
    t.binary   "invoice_copy",             :limit => 2097152
    t.boolean  "permanet_nonpayment",                         :default => false
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  add_index "invoices", ["order_id"], :name => "index_invoices_on_order_id"

  create_table "legacy_identifiers", :force => true do |t|
    t.string   "label"
    t.string   "description"
    t.string   "legacy_identifier"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "legacy_identifiers", ["label"], :name => "index_legacy_identifiers_on_label"
  add_index "legacy_identifiers", ["legacy_identifier"], :name => "index_legacy_identifiers_on_legacy_identifier"

  create_table "legacy_identifiers_master_files", :id => false, :force => true do |t|
    t.integer "legacy_identifier_id"
    t.integer "master_file_id"
  end

  add_index "legacy_identifiers_master_files", ["legacy_identifier_id"], :name => "index_legacy_identifiers_master_files_on_legacy_identifier_id"
  add_index "legacy_identifiers_master_files", ["master_file_id"], :name => "index_legacy_identifiers_master_files_on_master_file_id"

  create_table "master_files", :force => true do |t|
    t.integer  "availability_policy_id"
    t.integer  "component_id"
    t.integer  "indexing_scenario_id"
    t.integer  "use_right_id"
    t.integer  "unit_id",                                       :default => 0,     :null => false
    t.integer  "automation_messages_count",                     :default => 0
    t.string   "description"
    t.string   "filename"
    t.integer  "filesize"
    t.string   "md5"
    t.string   "title"
    t.text     "dc"
    t.text     "desc_metadata"
    t.boolean  "discoverability",                               :default => false
    t.string   "pid"
    t.text     "rels_ext"
    t.text     "rels_int"
    t.text     "solr",                      :limit => 16777215
    t.text     "transcription_text"
    t.datetime "date_dl_ingest"
    t.datetime "date_dl_update"
    t.datetime "date_archived"
    t.string   "tech_meta_type"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "master_files", ["availability_policy_id"], :name => "index_master_files_on_availability_policy_id"
  add_index "master_files", ["component_id"], :name => "index_master_files_on_component_id"
  add_index "master_files", ["filename"], :name => "index_master_files_on_filename"
  add_index "master_files", ["indexing_scenario_id"], :name => "index_master_files_on_indexing_scenario_id"
  add_index "master_files", ["pid"], :name => "index_master_files_on_pid"
  add_index "master_files", ["tech_meta_type"], :name => "index_master_files_on_tech_meta_type"
  add_index "master_files", ["title"], :name => "index_master_files_on_title"
  add_index "master_files", ["unit_id"], :name => "index_master_files_on_unit_id"
  add_index "master_files", ["use_right_id"], :name => "index_master_files_on_use_right_id"

  create_table "orders", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "dvd_delivery_location_id"
    t.integer  "customer_id",                                                      :default => 0,     :null => false
    t.integer  "units_count",                                                      :default => 0
    t.integer  "invoices_count",                                                   :default => 0
    t.integer  "automation_messages_count",                                        :default => 0
    t.integer  "master_files_count",                                               :default => 0
    t.datetime "date_canceled"
    t.datetime "date_deferred"
    t.date     "date_due"
    t.datetime "date_fee_estimate_sent_to_customer"
    t.datetime "date_order_approved"
    t.datetime "date_permissions_given"
    t.datetime "date_started"
    t.datetime "date_request_submitted"
    t.string   "entered_by"
    t.decimal  "fee_actual",                         :precision => 7, :scale => 2
    t.decimal  "fee_estimated",                      :precision => 7, :scale => 2
    t.boolean  "is_approved",                                                      :default => false, :null => false
    t.string   "order_status"
    t.string   "order_title"
    t.text     "special_instructions"
    t.text     "staff_notes"
    t.datetime "date_archiving_complete"
    t.datetime "date_customer_notified"
    t.datetime "date_finalization_begun"
    t.datetime "date_patron_deliverables_complete"
    t.text     "email"
    t.datetime "created_at",                                                                          :null => false
    t.datetime "updated_at",                                                                          :null => false
  end

  add_index "orders", ["agency_id"], :name => "index_orders_on_agency_id"
  add_index "orders", ["customer_id"], :name => "index_orders_on_customer_id"
  add_index "orders", ["date_archiving_complete"], :name => "index_orders_on_date_archiving_complete"
  add_index "orders", ["date_due"], :name => "index_orders_on_date_due"
  add_index "orders", ["date_order_approved"], :name => "index_orders_on_date_order_approved"
  add_index "orders", ["date_request_submitted"], :name => "index_orders_on_date_request_submitted"
  add_index "orders", ["dvd_delivery_location_id"], :name => "index_orders_on_dvd_delivery_location_id"
  add_index "orders", ["order_status"], :name => "index_orders_on_order_status"

  create_table "sql_reports", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "sql"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "unit_import_sources", :force => true do |t|
    t.integer  "unit_id",                          :default => 0, :null => false
    t.string   "standard"
    t.string   "version"
    t.text     "source",     :limit => 2147483647
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "unit_import_sources", ["unit_id"], :name => "index_unit_import_sources_on_unit_id"

  create_table "units", :force => true do |t|
    t.integer  "archive_id"
    t.integer  "availability_policy_id"
    t.integer  "bibl_id"
    t.integer  "heard_about_resource_id"
    t.integer  "indexing_scenario_id"
    t.integer  "use_right_id"
    t.integer  "order_id",                       :default => 0,     :null => false
    t.integer  "intended_use_id",                :default => 0,     :null => false
    t.integer  "master_files_count",             :default => 0
    t.integer  "automation_messages_count",      :default => 0
    t.datetime "date_archived"
    t.datetime "date_materials_received"
    t.datetime "date_materials_returned"
    t.datetime "date_patron_deliverables_ready"
    t.text     "patron_source_url"
    t.boolean  "remove_watermark",               :default => false, :null => false
    t.text     "special_instructions"
    t.text     "staff_notes"
    t.integer  "unit_extent_estimated"
    t.integer  "unit_extent_actual"
    t.string   "unit_status"
    t.datetime "date_queued_for_ingest"
    t.datetime "date_dl_deliverables_ready"
    t.boolean  "master_file_discoverability",    :default => false, :null => false
    t.boolean  "exclude_from_dl",                :default => false, :null => false
    t.boolean  "include_in_dl",                  :default => false, :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "units", ["archive_id"], :name => "index_units_on_archive_id"
  add_index "units", ["availability_policy_id"], :name => "index_units_on_availability_policy_id"
  add_index "units", ["bibl_id"], :name => "index_units_on_bibl_id"
  add_index "units", ["date_archived"], :name => "index_units_on_date_archived"
  add_index "units", ["date_dl_deliverables_ready"], :name => "index_units_on_date_dl_deliverables_ready"
  add_index "units", ["heard_about_resource_id"], :name => "index_units_on_heard_about_resource_id"
  add_index "units", ["indexing_scenario_id"], :name => "index_units_on_indexing_scenario_id"
  add_index "units", ["intended_use_id"], :name => "index_units_on_intended_use_id"
  add_index "units", ["order_id"], :name => "index_units_on_order_id"
  add_index "units", ["use_right_id"], :name => "index_units_on_use_right_id"

  create_table "use_rights", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "bibls_count",        :default => 0
    t.integer  "components_count",   :default => 0
    t.integer  "master_files_count", :default => 0
    t.integer  "units_count",        :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "use_rights", ["name"], :name => "index_use_rights_on_name", :unique => true

end
