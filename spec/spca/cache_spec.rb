# frozen_string_literal: true

module SPCA
  describe Cache do
    subject { Cache.new('/tmp') }

    before(:each) do
      @data = { fname: 'John', lname: 'Doe' }
      subject.clear
    end

    it '.path works' do
      expect(subject.path).to be('/tmp')
    end

    it '.set puts items in cache correctly' do
      expect(subject.set(@data.hash, @data)).to eql(@data)
      expect(File.exist?("/#{subject.path}/#{@data.hash}.cache")).to be true
    end

    it '.get returns the item for valid items' do
      subject.set(@data.hash, @data)

      expect(subject.get(@data.hash)).to eq(@data)
    end

    it '.get returns nil for non-existent items' do
      expect(subject.get(@data.hash)).to be_nil
    end

    it '.get returns nil for expired items' do
      subject.set(@data.hash, @data)
      FileUtils.touch(
        "#{subject.path}/#{@data.hash}.cache",
        mtime: Time.now - 61
      )

      expect(subject.get(@data.hash, 1)).to be_nil
    end

    it '.exist? returns true for valid items' do
      subject.set(@data.hash, @data)

      expect(subject.exist?(@data.hash)).to eq(true)
    end

    it '.exist? returns false for non-existent items' do
      expect(subject.exist?(@data.hash)).to be(false)
    end

    it '.exist? returns false for expired items' do
      subject.set(@data.hash, @data)
      FileUtils.touch(
        "#{subject.path}/#{@data.hash}.cache",
        mtime: Time.now - 61
      )

      expect(subject.exist?(@data.hash, 1)).to be(false)
    end

    it '.remove removes items' do
      subject.set(@data.hash, @data)
      subject.remove(@data.hash)
      expect(subject.get(@data.hash)).to be_nil
    end

    it '.clear removes all items' do
      subject.set('a', @data)
      subject.set('b', @data)

      subject.clear

      expect(subject.get('a')).to be_nil
      expect(subject.get('b')).to be_nil
    end
  end
end
