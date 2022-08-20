require 'minitest_helper'

describe Jobs::Status do

  let(:args_1) { {'param' => 1} }

  let(:args_2) { {'param' => 2} }

  it 'Enqueue' do
    jobs_args = [args_1, args_2, args_1]

    job_ids = jobs_args.map do |args|
      Jobs::Status.create args
    end

    assert_equal 3, job_ids.compact.uniq.count

    expected_payloads = job_ids.zip(jobs_args).map do |args|
      build_job_payload Jobs::Status, args
    end

    assert_equal expected_payloads, queued_in(default_queue)
  end

  it 'Enqueue to' do
    jobs_args = [args_1, args_2, args_1]

    job_ids = jobs_args.map do |args|
      Jobs::Status.enqueue_to :other_queue, Jobs::Status, args
    end

    assert_equal 3, job_ids.compact.uniq.count

    expected_payloads = job_ids.zip(jobs_args).map do |args|
      build_job_payload Jobs::Status, args
    end

    assert_equal expected_payloads, queued_in(:other_queue)
  end

  it 'Reserve' do
    job_id_1 = Jobs::Status.create args_1
    job_id_2 = Jobs::Status.create args_2

    job = Resque.reserve default_queue

    assert_equal build_job_payload(Jobs::Status, [job_id_1, args_1]), job.payload
    assert_equal [build_job_payload(Jobs::Status, [job_id_2, args_2])], queued_in(default_queue)
  end

  it 'Dequeue with args' do
    jobs_args = [args_1, args_2, args_1]

    job_ids = jobs_args.map do |args|
      Jobs::Status.create args
    end

    payloads = job_ids.zip(jobs_args).map do |args|
      build_job_payload Jobs::Status, args
    end

    assert_equal 1, Resque.dequeue(Jobs::Status, *payloads[0]['args'])

    assert_equal payloads[1..-1], queued_in(default_queue)
  end

  it 'Dequeue without args' do
    Jobs::Status.create args_1
    Jobs::Status.create args_2

    assert_equal 2, Resque.dequeue(Jobs::Status)

    assert_empty queued_in(default_queue)
  end

end