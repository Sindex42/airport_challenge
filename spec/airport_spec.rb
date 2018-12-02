require 'airport'

describe Airport do
  let(:plane) { Plane.new }
  # let(:airport) { double(:airpoort, weather: "sunny") }

  it { is_expected.to respond_to(:land).with(1).argument }
  it { is_expected.to respond_to(:in_airport?).with(1).argument }
  it { is_expected.to respond_to(:take_off).with(1).argument }

  it 'has a default capacity' do
    expect(subject.capacity).to eq described_class::DEFAULT_CAPACITY
  end

  describe '#land' do
    it 'lands a plane' do
      allow(subject).to receive(:weather) { "sunny" }
      expect(subject.land(plane)).to eq [plane]
    end

    it 'does not let the same plane land twice' do
      allow(subject).to receive(:weather) { "sunny" }
      subject.land(plane)

      expect { subject.land(plane) }.to raise_error 'Plane already landed'
    end

    it 'does not land if airport is at capacity' do
      allow(subject).to receive(:weather) { "sunny" }
      Airport::DEFAULT_CAPACITY.times { subject.land(Plane.new) }

      expect { subject.land(plane) }.to raise_error 'Airport at capacity'
    end

    it 'does not land if the weather is stormy' do
      allow(subject).to receive(:weather) { "stormy" }

      expect { subject.land(plane) }.to raise_error 'Plane cannot land due to stormy weather'
    end
  end

  describe '#take_off' do
    it 'lets a plane take_off' do
      allow(subject).to receive(:weather) { "sunny" }
      subject.land(plane)
      subject.take_off(plane)

      expect(subject.hangar).to eq []
    end

    it 'does not let the same plane take_off twice' do
      allow(subject).to receive(:weather) { "sunny" }
      subject.land(plane)
      subject.take_off(plane)

      expect { subject.take_off(plane) }.to raise_error 'Plane already flying'
    end

    it 'does not take_off if the plane is not in the current airport' do
      airport1 = Airport.new
      airport2 = Airport.new
      allow(airport1).to receive(:weather) { "sunny" }
      allow(airport2).to receive(:weather) { "sunny" }
      airport1.land(plane)

      expect { airport2.take_off(plane) }.to raise_error 'Plane not in current airport'
    end

    it 'does not take_off if the weather is stormy' do
      allow(subject).to receive(:weather) { "sunny" }
      subject.land(plane)
      allow(subject).to receive(:weather) { "stormy" }

      expect { subject.take_off(plane) }.to raise_error 'Plane cannot take_off due to stormy weather'
    end
  end

  describe '#in_airport?' do
    it 'checks if a plane is not in an airport' do
      expect(subject.in_airport?(plane)).to eq false
    end

    it 'checks if a plane is in an airport' do
      allow(subject).to receive(:weather) { "sunny" }
      subject.land(plane)

      expect(subject.in_airport?(plane)).to eq true
    end
  end

end
