require 'thread/pool'

require 'thread/channel'
require 'rspec'

describe Thread::Pool do
	it 'processes all of its inputs' do
    
    channel = Thread.channel
    pool = Thread.pool 15
    in_numbers = (0..100).to_a
    
    in_numbers.each {|i|
      pool.process {
        sleep rand(0.5)
        channel.send i
      }
    }

    pool.shutdown


    out_numbers = []
    in_numbers.size.times{|numb|
      out_numbers << channel.receive
    }

    expect(out_numbers.size).to be(in_numbers.size)
    in_numbers.each{|numb|
      expect(out_numbers).to include(numb)
    }
	end

end
