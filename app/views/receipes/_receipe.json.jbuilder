json.extract! receipe, :id, :name, :description, :created_at, :updated_at
json.url receipe_url(receipe, format: :json)
