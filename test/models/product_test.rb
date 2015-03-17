require 'test_helper'
class ProductTest < ActiveSupport::TestCase
  fixtures :products

  def new_product(name)
    return Product.new(title: "aaa",
                description: "bbb",
                price: 1,
                image_url: name)
  end

  test "the attribues must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price mut be positive" do
    product = Product.new(
                         title: "My Little Book",
                         description: "My little book description",
                         image_url: "zzz.jpg"
    )
    product.price = -1
    assert product.invalid?
    product.errors[:price].join('; ')
    product.price = 0
    assert product.invalid?
    product.errors[:price].join('; ')
    product.price = 1
    assert product.valid?
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/a/b/c/freg.jpg 123.jpg http://q.w.e/1/2/3345-32.jpg }
    bad = %w{ fred.doc fred.gif/more fred.gif.more fred.gi fred.gifg}

    ok.each do |name|
      assert new_product(name).valid?, "#{name} is invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} is valid"
    end
  end

  test "unic name" do
    product = Product.new(title: products(:ruby).title,
    description: products(:ruby).description,
    price: products(:ruby).price,
    image_url: "321.jpg")
    assert !product.save
    #assert_equal I18n.translate('aciverecord.errors.message.taken'), product.errors[:title].join('; ')
  end
end
