class Deck
  private_class_method :new
  attr_accessor :cards

  def self.instance
    @@instance ||= new
  end

  def initialize
    array = []

    ['-Or', '-Ba', '-Es', '-Co'].each do |i|
      (1..12).each do |j|
        array.push(j.to_s + i)
      end
    end

    @cards = array
  end

  def get_card
    @cards[Random.rand(48)]
  end
end
