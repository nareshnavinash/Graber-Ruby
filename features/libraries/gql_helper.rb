require 'graphql/client'
require 'graphql/client/http'
require 'rest-client'

module Graber
    @@http_client = nil
    @@query = {}
    @@response_json = {}
    @@variables = {}
    @@response_errors = []
    @@access_token = nil
    @@client = nil
    @@uid = nil

    class GqlHelper

        def initialize(graphql_endpoint, username = nil, password = nil)
            login_using_username_password(graphql_endpoint, username, password) if username != nil
            create_gql_client(graphql_endpoint)
        end

        def login_using_username_password(graphql_endpoint, username, password)
            begin
                http_auth_response = RestClient.post "#{graphql_endpoint}/login", {email: "#{userName}", password: "#{passKey}"}
                if http_auth_response.code != 200
                    puts "Authentication failed \n #{http_auth_response}"
                    return false
                end
                @@access_token =  http_auth_response.headers[:access_token]
                @@client =  http_auth_response.headers[:client]
                @@uid =  http_auth_response.headers[:uid]
                return true
            rescue => e
                puts "Authentication failed #{e.message}"
                return false
            end
        end

        def create_gql_client(graphql_endpoint)
            begin
                @http_adaptor = GraphQL::Client::HTTP.new("#{graphql_endpoint}") do
                    if @@access_token == nil
                        def headers(context)
                            {"Content-Type": "application/json",
                            "Accept": "*/*",
                            "Cache-Control": "no-cache",
                            "Host": "www.graphqlhub.com",
                            "Accept-Encoding": "gzip, deflate",
                            "Connection": "keep-alive",
                            "User-Agent": "PostmanRuntime/7.21.0",
                            "Postman-Token": "546e02e7-c331-4cd7-be93-04c9c9060d83"
                            }
                        end
                    else
                        def headers(context)
                            {"Content-Type": "application/json",
                            "Accept": "*/*",
                            "access-token": @@access_token,
                            "client": @@client,
                            "uid": @@uid
                            }
                        end
                    end
                end
                @http_schema = GraphQL::Client.load_schema(@http_adaptor)
                @@http_client = GraphQL::Client.new(schema: @http_schema, execute: @http_adaptor)
                @@http_client.allow_dynamic_queries = true
            rescue Exception => e
                #enable logger for this method - VT
                puts "Error occured while creating graphql client \n" + e.message
            end
        end

        def self.parse(query)
            begin
                @@query = query
                return @@http_client.parse(query)
            rescue Exception => e
                puts "Query cannot be parsed \n #{e.message}"
                return nil
            end
        end

        def self.execute(variables = nil)
            begin
                @@variables = variables
                if variable == nil
                    @@response_json = @@http_client.query(query)
                else
                    @@response_json = @@http_client.query(query, variables: variables)
                end
                @@response_errors = @@response_json.to_h["errors"]
                return @@response_json
            rescue Exception => e
                puts "Query cannot be parsed \n #{e.message}"
                return nil
            end
        end
    end
end
