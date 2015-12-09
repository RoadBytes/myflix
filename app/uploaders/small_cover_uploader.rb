class SmallCoverUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  process :scale => [166, 236]
end
