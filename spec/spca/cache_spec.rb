# frozen_string_literal: true

module SPCA
  describe Cache do
    DATA = { fname: 'John', lname: 'Doe' }

    subject { Cache.new('/tmp') }

    before(:each) do
      subject.clear
    end

    it '.path works' do
      expect(subject.path).to be('/tmp')
    end

    it '.set puts items in cache correctly' do
      expect(subject.set(DATA.hash, DATA)).to eql(DATA)
      expect(File.exist? "/#{subject.path}/#{DATA.hash}.cache").to be true
    end

    it '.get returns the item for valid items' do
      subject.set(DATA.hash, DATA)

      expect(subject.get(DATA.hash)).to eq(DATA)
    end

    it '.get returns nil for non-existent items' do
      expect(subject.get(DATA.hash)).to be_nil
    end

    it '.get returns nil for expired items' do
      subject.set(DATA.hash, DATA)
      FileUtils.touch(
        "#{subject.path}/#{DATA.hash}.cache",
        :mtime => Time.now - 61
      )

      expect(subject.get(DATA.hash, 1)).to be_nil
    end

    it '.exist? returns true for valid items' do
      subject.set(DATA.hash, DATA)

      expect(subject.exist?(DATA.hash)).to eq(true)
    end

    it '.exist? returns false for non-existent items' do
      expect(subject.exist?(DATA.hash)).to be(false)
    end

    it '.exist? returns false for expired items' do
      subject.set(DATA.hash, DATA)
      FileUtils.touch(
        "#{subject.path}/#{DATA.hash}.cache",
        :mtime => Time.now - 61
      )

      expect(subject.exist?(DATA.hash, 1)).to be(false)
    end

    it '.remove removes items' do
      subject.set(DATA.hash, DATA)
      subject.remove(DATA.hash)
      expect(subject.get(DATA.hash)).to be_nil
    end

    it '.clear removes all items' do
      subject.set('a', DATA)
      subject.set('b', DATA)

      subject.clear

      expect(subject.get('a')).to be_nil
      expect(subject.get('b')).to be_nil
    end
  end
end
