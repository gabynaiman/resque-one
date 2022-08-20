require 'minitest_helper'

describe Jobs::StatusOne do

  let(:args_1) { {'param' => 1} }

  let(:args_2) { {'param' => 2} }

  it 'Enqueue' do
    jobs_args = [args_1, args_2, args_1]

    job_ids = jobs_args.map do |args|
      Jobs::StatusOne.create args
    end

    assert_equal 2, job_ids.compact.uniq.count
    assert_nil job_ids.last

    expected_payloads = job_ids.compact.zip(jobs_args).map do |args|
      build_job_payload Jobs::StatusOne, args
    end

    assert_equal expected_payloads, queued_in(default_queue)
  end

  it 'Enqueue to' do
    jobs_args = [args_1, args_2, args_1]

    job_ids = jobs_args.map do |args|
      Jobs::StatusOne.enqueue_to :other_queue, Jobs::StatusOne, args
    end

    assert_equal 2, job_ids.compact.uniq.count
    assert_nil job_ids.last

    expected_payloads = job_ids.compact.zip(jobs_args).map do |args|
      build_job_payload Jobs::StatusOne, args
    end

    assert_equal expected_payloads, queued_in(:other_queue)
  end

  it 'Reserve' do
    job_id_1 = Jobs::StatusOne.create args_1
    job_id_2 = Jobs::StatusOne.create args_2

    job = Resque.reserve default_queue

    assert_equal build_job_payload(Jobs::StatusOne, [job_id_1, args_1]), job.payload
    assert_equal [build_job_payload(Jobs::StatusOne, [job_id_2, args_2])], queued_in(default_queue)
  end

  it 'Dequeue with args' do
    jobs_args = [args_1, args_2]

    job_ids = jobs_args.map do |args|
      Jobs::StatusOne.create args
    end

    payloads = job_ids.zip(jobs_args).map do |args|
      build_job_payload Jobs::StatusOne, args
    end

    assert_equal 1, Resque.dequeue(Jobs::StatusOne, *payloads.first['args'])

    assert_equal [payloads.last], queued_in(default_queue)
  end

  it 'Dequeue without args' do
    Jobs::StatusOne.create args_1
    Jobs::StatusOne.create args_2

    assert_equal 2, Resque.dequeue(Jobs::StatusOne)

    assert_empty queued_in(default_queue)
  end

  describe 'Unlock' do

    before do
      assert Jobs::StatusOne.create(args_1)
      refute Jobs::StatusOne.create(args_1)
    end

    it 'After reserve' do
      Resque.reserve default_queue

      assert Jobs::StatusOne.create(args_1)
    end

    it 'After dequeue' do
      Resque.dequeue Jobs::StatusOne

      assert Jobs::StatusOne.create(args_1)
    end

    it 'After remove queue' do
      Resque.remove_queue default_queue

      assert Jobs::StatusOne.create(args_1)
    end

  end

end