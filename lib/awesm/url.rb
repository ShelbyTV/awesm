module Awesm
  class Url
    include HTTParty
    base_uri 'http://api.awe.sm/url'
    format :json
    
    
    REQUIRED_SHARE_PARAMS = [:url, :key, :tool, :channel, :destination].freeze
    REQUIRED_STATIC_PARAMS = [:format, :url, :key, :tool].freeze
    REQUIRED_BATCH_PARAMS = [:url, :channel, :key, :tool].freeze

    def self.share(params = {})
      if required_params_present?(REQUIRED_SHARE_PARAMS, params)
        options = params.clone
        options = options.delete_if{|key,value| REQUIRED_SHARE_PARAMS.include?(key) }
        query = options.map{|k,v| "#{k}=#{v}"}.join('&')
        share_url = "http://api.awe.sm/url/share?v=3&url=#{params[:url]}&key=#{params[:key]}&tool=#{params[:tool]}&channel=#{params[:channel]}&destination=#{params[:destination]}"
        share_url += "&#{query}" if query.length > 0
        share_url
      end
    end

    def self.static(params = {})
      if required_params_present?(REQUIRED_STATIC_PARAMS, params)
        options = params.clone
        options = options.delete_if{|key,value| REQUIRED_STATIC_PARAMS.include?(key) }
        query = options.map{|k,v| "#{k}=#{v}"}.join('&')
        static_url = "http://api.awe.sm/url/static.#{params[:format]}?v=3&url=#{params[:url]}&key=#{params[:key]}&tool=#{params[:tool]}"
        static_url += "&#{query}" if query.length > 0
        static_url
      end
    end
    
    def self.batch(params = {})
      if required_params_present?(REQUIRED_BATCH_PARAMS, params)        
        channels = params[:channel].split(',')
        channels.map! { |c| "channel[]=#{c}" }
        channel_list = channels.join('&')

        share_uri = "/batch.json?v=3&url=#{params[:url]}&key=#{params[:key]}&tool=#{params[:tool]}&#{channel_list}"
        
        response = post share_uri
        
        response.code, response.parsed_response
      end
    end

    def self.required_params_present?(required_params, params)
      required_params.all? do |param|
        params.include?(param)
      end
    end
  end
end
