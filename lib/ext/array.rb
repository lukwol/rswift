class Array

  def all_combinations
    all_combinations = []
    0.upto(count) do |n|
      combination(n).each do |combination|
        all_combinations << combination
      end
    end
    all_combinations
  end
end
