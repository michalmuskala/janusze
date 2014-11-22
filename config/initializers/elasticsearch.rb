options = if Rails.env.production?
  {
    :hosts => [
      {
        :host => 'elastyczne-janusze-6425086879.eu-west-1.bonsai.io',
        :user => '67tq7o1g2i',
        :password => 'qt85bai8kg'
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