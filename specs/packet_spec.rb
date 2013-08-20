require 'minitest/autorun'
require 'minitest/spec'

require 'telehash'

Packet = Telehash::Packet

describe Packet do
  describe 'creation' do
    it 'can be created from just an empty hash' do
      p = Packet.new({})
      p.must_be_instance_of Packet
      p.json.must_be_instance_of Hash
      p.to_s.must_equal "\0\2{}".encode("UTF-8")
    end
    it 'can be created from an empty hash with data' do
      p = Packet.new({}, "abcd")
      p.must_be_instance_of Packet
      p.json.must_be_instance_of Hash
      p.data.must_be_instance_of String
      p.to_s.must_equal "\0\2\{}abcd".encode("UTF-8")
    end
    it 'can be created with non-empty json' do
      p = Packet.new({a: 'b'})
      p.must_be_instance_of Packet
      p.json.must_be_instance_of Hash
      p.to_s.must_equal "\0\t{\"a\":\"b\"}".encode("UTF-8")
    end
  end
  describe 'parsing' do
    it 'can parse an empty message' do
      raw_packet = "\0\2{}".encode("binary")
      p = Packet.parse raw_packet 
      p.must_be_instance_of Packet
      p.json.must_be_instance_of Hash
      p.data.must_be_nil
      p.to_s.must_equal raw_packet
    end
    it 'can parse an empty hash with data' do
      raw_packet = "\0\2\{}abcd".encode("UTF-8")
      p = Packet.parse raw_packet
      p.must_be_instance_of Packet
      p.json.must_be_instance_of Hash
      p.data.must_be_instance_of String
      p.data.must_equal "abcd"
      p.to_s.must_equal raw_packet
    end
    it 'can parse non-empty json' do
      raw_packet = "\0\t{\"a\":\"b\"}".encode("UTF-8")
      p = Packet.parse raw_packet
      p.must_be_instance_of Packet
      p.json.must_be_instance_of Hash
      p.json["a"].must_equal "b"
      p.to_s.must_equal raw_packet
    end
  end
end
