require 'test_helper'

module CDMBL

  describe Transformer do
    let(:cdm_records) { [{'title' => 'The Three-Body Problem'}] }
    let(:record_transformer) { Minitest::Mock.new }
    let(:record_transformer_object) { Minitest::Mock.new }

    it "transforms each record" do
      record_transformer.expect :new, record_transformer_object, [{:record=>{"title"=>"The Three-Body Problem", "oai_sets"=>{}}, :field_mappings=>[{:dest_path=>"location_llsi", :origin_path=>"/", :formatters=>[CDMBL::LocationFormatter]}, {:dest_path=>"id", :origin_path=>"id", :formatters=>[CDMBL::StripFormatter, CDMBL::IDFormatter]}, {:dest_path=>"setspec_ssi", :origin_path=>"/", :formatters=>[CDMBL::AddSetSpecFormatter, CDMBL::SetSpecFormatter]}, {:dest_path=>"collection_name_ssi", :origin_path=>"/", :formatters=>[CDMBL::AddSetSpecFormatter, CDMBL::CollectionNameFormatter]}, {:dest_path=>"collection_name_tei", :origin_path=>"/", :formatters=>[CDMBL::AddSetSpecFormatter, CDMBL::CollectionNameFormatter]}, {:dest_path=>"collection_description_tesi", :origin_path=>"/", :formatters=>[CDMBL::AddSetSpecFormatter, CDMBL::CollectionDescriptionFormatter, CDMBL::FilterBadCollections]}, {:dest_path=>"parent_collection_name_ssi", :origin_path=>"par", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"parent_collection_name_tei", :origin_path=>"par", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"parent_collection_description_tei", :origin_path=>"par", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"title_tei", :origin_path=>"title", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"title_ssi", :origin_path=>"title", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"title_sort", :origin_path=>"title", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"title_unstem_search", :origin_path=>"title", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"contributor_teim", :origin_path=>"contri", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"contributor_unstem_search", :origin_path=>"contri", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"contributor_ssim", :origin_path=>"contri", :formatters=>[CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"creator_teim", :origin_path=>"photog", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"creator_unstem_search", :origin_path=>"photog", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"creator_ssim", :origin_path=>"photog", :formatters=>[CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"creator_sort", :origin_path=>"photog", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"description_tei", :origin_path=>"descri", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"description_ts", :origin_path=>"descri", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"dat_ssi", :origin_path=>"dat", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"dat_sort", :origin_path=>"dat", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"publishing_agency_tei", :origin_path=>"publia", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"publishing_agency_unstem_search", :origin_path=>"publia", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"publishing_agency_ssi", :origin_path=>"publia", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"dimensions_ssi", :origin_path=>"dimens", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"topic_teim", :origin_path=>"genera", :formatters=>[CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"topic_ssim", :origin_path=>"genera", :formatters=>[CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"topic_unstem_search", :origin_path=>"genera", :formatters=>[CDMBL::StripSemicolonFormatter, CDMBL::StripFormatter]}, {:dest_path=>"type_ssi", :origin_path=>"type", :formatters=>[CDMBL::Titlieze, CDMBL::StripSemicolonFormatter, CDMBL::StripFormatter]}, {:dest_path=>"physical_format_ssi", :origin_path=>"physic", :formatters=>[CDMBL::StripSemicolonFormatter]}, {:dest_path=>"physical_format_tei", :origin_path=>"physic", :formatters=>[CDMBL::StripSemicolonFormatter]}, {:dest_path=>"formal_subject_unstem_search", :origin_path=>"specif", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"formal_subject_ssim", :origin_path=>"specif", :formatters=>[CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"formal_subject_teim", :origin_path=>"specif", :formatters=>[CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"subject_unstem_search", :origin_path=>"subjec", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"subject_teim", :origin_path=>"subjec", :formatters=>[CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"subject_ssim", :origin_path=>"subjec", :formatters=>[CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"keyword_unstem_search", :origin_path=>"/", :formatters=>[CDMBL::KeywordFormatter, CDMBL::StripFormatter]}, {:dest_path=>"keyword_teim", :origin_path=>"/", :formatters=>[CDMBL::KeywordFormatter, CDMBL::StripFormatter]}, {:dest_path=>"keyword_ssim", :origin_path=>"/", :formatters=>[CDMBL::KeywordFormatter, CDMBL::StripFormatter]}, {:dest_path=>"city_ssim", :origin_path=>"city", :formatters=>[CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"city_unstem_search", :origin_path=>"city", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"district_ssi", :origin_path=>"distri", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"district_unstem_search", :origin_path=>"distri", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"county_ssim", :origin_path=>"county", :formatters=>[CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"county_unstem_search", :origin_path=>"county", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"state_ssi", :origin_path=>"state", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"state_unstem_search", :origin_path=>"state", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"country_ssi", :origin_path=>"countr", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"country_unstem_search", :origin_path=>"countr", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"language_ssi", :origin_path=>"langua", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"language_unstem_search", :origin_path=>"langua", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"contributing_unstem_search", :origin_path=>"contra", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"contributing_organization_tei", :origin_path=>"contra", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"contributing_organization_ssi", :origin_path=>"contra", :formatters=>[CDMBL::Titlieze, CDMBL::StripFormatter]}, {:dest_path=>"contact_information_ssi", :origin_path=>"contac", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"rights_ssi", :origin_path=>"righta", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"local_identifier_ssi", :origin_path=>"identi", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"identifier_ssi", :origin_path=>"resour", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"project_ssi", :origin_path=>"projec", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"fiscal_sponsor_ssi", :origin_path=>"fiscal", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"publisher_ssi", :origin_path=>"publis", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"date_ssi", :origin_path=>"date", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"format_ssi", :origin_path=>"format", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"digspa_ssi", :origin_path=>"digspa"}, {:dest_path=>"digspb_ssi", :origin_path=>"digspb"}, {:dest_path=>"digspc_ssi", :origin_path=>"digspc"}, {:dest_path=>"digspd_ssi", :origin_path=>"digspd"}, {:dest_path=>"digspe_ssi", :origin_path=>"digspe"}, {:dest_path=>"digspf_ssi", :origin_path=>"digspf"}, {:dest_path=>"digspg_ssi", :origin_path=>"digspg"}, {:dest_path=>"digsph_ssi", :origin_path=>"digsph"}, {:dest_path=>"digspi_ssi", :origin_path=>"digspi"}, {:dest_path=>"digspj_ssi", :origin_path=>"digspj"}, {:dest_path=>"digspk_ssi", :origin_path=>"digspk"}, {:dest_path=>"transcription_tesi", :origin_path=>"transc", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"translation_tesi", :origin_path=>"transl", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"fullrs_tes", :origin_path=>"fullrs", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"find_ssi", :origin_path=>"find", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"dmaccess_ssi", :origin_path=>"dmaccess", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"dmimage_ssi", :origin_path=>"dmimage", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"dmcreated_ssi", :origin_path=>"dmcreated", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"dmmodified_ssi", :origin_path=>"dmmodified", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"dmoclcno_ssi", :origin_path=>"dmoclcno", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"restriction_code_ssi", :origin_path=>"restrictionCode", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"cdmfilesize_ssi", :origin_path=>"cdmfilesize", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"cdmfilesizeformatted_ssi", :origin_path=>"cdmfilesizeformatted", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"cdmprintpdf_is", :origin_path=>"cdmprintpdf", :formatters=>[CDMBL::ToIFormatter]}, {:dest_path=>"cdmhasocr_is", :origin_path=>"cdmhasocr", :formatters=>[CDMBL::ToIFormatter]}, {:dest_path=>"cdmisnewspaper_is", :origin_path=>"cdmisnewspaper", :formatters=>[CDMBL::ToIFormatter]}, {:dest_path=>"image_uri_ssi", :origin_path=>"image_uri", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"record_type_ssi", :origin_path=>"record_type", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"geographic_feature_ssim", :origin_path=>"geogra", :formatters=>[CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]}, {:dest_path=>"geographic_feature_teim", :origin_path=>"geogra", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"geographic_feature_unstem_search", :origin_path=>"geogra", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"compound_objects_ts", :origin_path=>"page", :formatters=>[CDMBL::ToJsonFormatter]}, {:dest_path=>"geonam_ssi", :origin_path=>"geonam", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"kaltura_audio_ssi", :origin_path=>"audio", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"kaltura_audio_playlist_ssi", :origin_path=>"audioa", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"kaltura_video_ssi", :origin_path=>"video", :formatters=>[CDMBL::StripFormatter]}, {:dest_path=>"coordinates_llsi", :origin_path=>"geonam", :formatters=>[CDMBL::GeoNameID, CDMBL::GeoNameIDToJson, CDMBL::GeoNameToLocation]}, {:dest_path=>"placename_ssim", :origin_path=>"geonam", :formatters=>[CDMBL::GeoNameID, CDMBL::GeoNameIDToJson, CDMBL::GeoNameToPlaceName]}, {:dest_path=>"placename_unstem_search", :origin_path=>"geonam", :formatters=>[CDMBL::GeoNameID, CDMBL::GeoNameIDToJson, CDMBL::GeoNameToPlaceName]}]}]
      record_transformer_object.expect :transform!, {'title' => 'The Three-Body Problem'}
      Transformer.new(cdm_records: cdm_records, record_transformer: record_transformer).records
      record_transformer.verify
      record_transformer_object.verify
    end

    it "transforms kaltura media metadata" do
      records = [{
                    'id' => 'foo/123',
                    'audioa' => '0_sdfsdf',
                    'audio' => '0_eenv',
                    'video' => '0_w3vvA'
                }]
      transformation = Transformer.new(cdm_records: records).records.first
      transformation['kaltura_audio_ssi'].must_equal '0_eenv'
      transformation['kaltura_video_ssi'].must_equal '0_w3vvA'
      transformation['kaltura_audio_playlist_ssi'].must_equal '0_sdfsdf'
    end

    it "enriches from GeoNames service" do
      records = [{
                    'id' => 'foo/123',
                    'geonam' => 'http://sws.geonames.org/5024729/'
                }]
      VCR.use_cassette("geonames_request_location") do
        transformation = Transformer.new(cdm_records: records).records.first
        transformation['coordinates_llsi'].must_equal '46.78111,-92.11806'
      end

      VCR.use_cassette("geonames_request_placename") do
        transformation = Transformer.new(cdm_records: records).records.first
        transformation['placename_ssim'].must_equal ["Duluth, City of", "Saint Louis County"]
      end

      VCR.use_cassette("geonames_request_search_placename") do
        transformation = Transformer.new(cdm_records: records).records.first
        transformation['placename_unstem_search'].must_equal ["Duluth, City of", "Saint Louis County"]
      end
    end
  end
end