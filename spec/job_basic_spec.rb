require 'minitest_helper'

describe Jobs::Basic do

  let(:args_1) { [1, 2, 3] }

  let(:args_2) { [4, 5, 6] }

  it 'Enqueue' do
    jobs_args = [args_1, args_2, args_1]

    jobs_args.each do |args|
      assert Resque.enqueue(Jobs::Basic, *args)
    end

    expected_payloads = jobs_args.map do |args|
      build_job_payload Jobs::Basic, args
    end

    assert_equal expected_payloads, queued_in(default_queue)
  end

  it 'Enqueue to' do
    jobs_args = [args_1, args_2, args_1]

    jobs_args.each do |args|
      assert Resque.enqueue_to(:other_queue, Jobs::Basic, *args)
    end

    expected_payloads = jobs_args.map do |args|
      build_job_payload Jobs::Basic, args
    end

    assert_equal expected_payloads, queued_in(:other_queue)
  end

  it 'Reserve' do
    Resque.enqueue Jobs::Basic, *args_1
    Resque.enqueue Jobs::Basic, *args_2

    job = Resque.reserve default_queue

    assert_equal build_job_payload(Jobs::Basic, args_1), job.payload
    assert_equal [build_job_payload(Jobs::Basic, args_2)], queued_in(default_queue)
  end

  it 'Dequeue with args' do
    Resque.enqueue Jobs::Basic, *args_1
    Resque.enqueue Jobs::Basic, *args_2
    Resque.enqueue Jobs::Basic, *args_1

    assert_equal 2, Resque.dequeue(Jobs::Basic, *args_1)

    assert_equal [build_job_payload(Jobs::Basic, args_2)], queued_in(default_queue)
  end

  it 'Dequeue without args' do
    Resque.enqueue Jobs::Basic, *args_1
    Resque.enqueue Jobs::Basic, *args_2

    assert_equal 2, Resque.dequeue(Jobs::Basic)

    assert_empty queued_in(default_queue)
  end

end