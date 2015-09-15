require_relative './lib/helpers'
require_relative './lib/configuration'
require_relative './lib/cache'
require_relative './lib/db'
require_relative './lib/rich_list'
require_relative './lib/env'
require_relative './lib/version'
require_relative './lib/explorer_app'
require_relative './lib/frontend_app'

module BceExplorer
  # Engine class creates web applications
  # one sinatra app per coin + app for coin list
  class Engine
    attr_reader :coins

    def initialize(root)
      Env.root = root
      @coins = {}
      Dir["#{root}/config/coins/*.yml"].each do |coin_path|
        _config = Configuration.new coin_path
        @coins[_config.info['Tag'].downcase] = _config
      end
    end

    def explorer_app(coin)
      ExplorerApp.new coin
    end

    def frontend_app
      FrontendApp.new @coins
    end

    def sync_rich_list
      @coins.each do |tag, coin|
        puts "Syncing coin #{tag.upcase} ..."
        rich_list(coin.client, coin.db).sync!
      end
    end

    private

    def rich_list(client, db)
      RichList.new blockexplorer: client, database: db
    end
  end
end
