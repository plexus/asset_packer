require 'pathname'
require 'net/http'
require 'base64'
require 'optparse'

require 'hexp'
require 'mime/types'

module AssetPackager
  ROOT = Pathname(__FILE__).dirname.parent
end

require 'asset_packager/version'
require 'asset_packager/cli'
require 'asset_packager/processor'
require 'asset_packager/processor/local'
require 'asset_packager/processor/stand_alone'
require 'asset_packager/processor/chain'
