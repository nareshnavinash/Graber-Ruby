require 'graphql/client'
require 'graphql/client/http'
require 'rest-client'

module Graber
    @@http_client = nil
    @@query = {}
    @@response = {}
    @@variables = {}

    class GqlHelper

        def initialize(Graphql_endpoint, username = nil, password = nil)
            login_using_username_password(Graphql_endpoint, username, password)
            create_gql_client(Graphql_endpoint)
        end

        def login_using_username_password(Graphql_endpoint, username, password)
            begin
                http_auth_response = RestClient.post "#{url_for_rest_client}/relationship_manager_users/sign_in", {email: "#{userName}", password: "#{passKey}"}
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

        def create_gql_client(Graphql_endpoint)
            begin
                @http_adaptor = GraphQL::Client::HTTP.new(Graphql_endpoint) do
                    def headers(context)
                        {"Content-Type": "application/json",
                        "Accept": "application/json",
                        "access-token": @@access_token,
                        "client": @@client,
                        "uid": @@uid
                        }
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
                    @@response = @@http_client.query(query)
                else
                    @@response = @@http_client.query(query, variables: variables)
                end
                return @@response
            rescue Exception => e
                puts "Query cannot be parsed \n #{e.message}"
                return nil
            end
        end
    end
end
