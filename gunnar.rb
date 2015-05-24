require 'dotenv'
Dotenv.load

require 'aws-sdk'
require 'require_all'

require_all 'lib'
require_all 'flows'


credentials = Aws::Credentials.new(ENV['AWS_ID'], ENV['AWS_SECRET'])
sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'], credentials: credentials)

poller = Aws::SQS::QueuePoller.new(ENV['AWS_SQS_QUEUE_URL'], client: sqs)
poller.poll(wait_time_seconds: 5, max_number_of_messages: 10) do |messages|
  messages.each do |message|
    payload = JSON.parse(message.body)
    Gunnar::Flows.constants.each do |flow|
      Gunnar::Flows.const_get(flow).run(payload)
    end
  end
end
