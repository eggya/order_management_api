Factory.define :product do |p|
  p.sequence(:name) {|n|  "name#{n}" }
  p.price           12.0
end

Factory.define :order do |o|
  o.status          1
end