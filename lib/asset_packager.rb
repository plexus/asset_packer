require 'pathname'
require 'net/http'
require 'base64'

require 'hexp'
require 'mime/types'

module AssetPackager
  ROOT = Pathname(__FILE__).dirname.parent
end

require 'asset_packager/version'
require 'asset_packager/processor'
