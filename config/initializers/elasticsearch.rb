options = if Rails.env.production?
  {
    :hosts => [
      {
        :host => '67tq7o1g2i:qt85bai8kg@elastyczne-janusze-6425086879.eu-west-1.bonsai.io',
        :port => 80,
        :scheme => 'https'
      }
    ],
    :log => false,
    :trace => false
  }
else
  {
    :log => true,
    :logger => Logger.new(Rails.root.join('log', 'elasticsearch.log')),
    :trace => true,
    :tracer => Logger.new(Rails.root.join('log', 'elasticsearch-trace.log'))
  }
end

Elasticsearch::Model.client = Elasticsearch::Client.new(options)