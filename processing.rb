require 'json'

class Processing
  def call(json)
    payload = build_payload(json)

    payload
  end

  def build_payload(json)
    {
      'externalCode': external_code(json),
      'storeId': store_id(json),
      'subTotal': sub_total(json),
      'deliveryFee': delivery_fee(json),
      'total': total(json),
      'country': country(json),
      'state': state(json),
      'city': city(json),
      'district': district(json),
      'street': street(json),
      'complement': complement(json),
      'latitude': latitude(json),
      'longitude': longitude(json),
      'dtOrderCreate': dt_order_create(json),
      'postalCode': postal_code(json),
      'number': number(json),
      'customer': customer(json),
      'items': items(json),
      'payments': payments(json)
    }
  end
  
  private

  def external_code(json)
    json['id'].to_s
  end

  def store_id(json)
    json['store_id']
  end

  def sub_total(json)
    '%.2f' % json['total_amount']
  end

  def delivery_fee(json)
    json['total_shipping'].to_s
  end

  def total(json)
    json['total_amount_with_shipping'].to_s
  end

  def country(json)
    json['shipping']['receiver_address']['country']['id']
  end

  def state(json)
    json['shipping']['receiver_address']['state']['name']
  end

  def city(json)
    json['shipping']['receiver_address']['city']['name']
  end

  def district(json)
    json['shipping']['receiver_address']['neighborhood']['name']
  end

  def street(json)
    json['shipping']['receiver_address']['street_name']
  end

  def complement(json)
    json['shipping']['receiver_address']['comment']
  end

  def latitude(json)
    json['shipping']['receiver_address']['latitude']
  end

  def longitude(json)
    json['shipping']['receiver_address']['longitude']
  end

  def dt_order_create(json)
    json['date_created']
  end

  def postal_code(json)
    json['shipping']['receiver_address']['zip_code']
  end

  def number(json)
    json['shipping']['receiver_address']['street_number']
  end

  def customer(json)
    client = json['buyer']
    clients_phone = json['buyer']['phone']

    {
      'externalCode': client['id'].to_s,
      'name': client['nickname'].to_s,
      'email': client['email'].to_s,
      'contact': "#{clients_phone['area_code']}#{clients_phone['number']}"
    }
  end

  def items(json)
    json['order_items'].map do |item|
      {
        'externalCode': item['item']['id'],
        'name': item['item']['title'],
        'price': item['full_unit_price'],
        'quantity': item['quantity'],
        'total': item['unit_price'] * item['quantity'],
        'subItems': []
      }
    end
  end

  def payments(json)
    json['payments'].map do |pay|
      {
        'type': pay['payment_type'].upcase,
        'value': pay['total_paid_amount']
      }
    end
  end
end

# json = File.read('payload.json')
# parsed_json = JSON.parse(json)
# payload = Processing.new.call(parsed_json)

# p payload