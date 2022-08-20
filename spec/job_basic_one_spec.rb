require 'minitest_helper'

describe Jobs::BasicOne do

  let(:args_1) { [1, 2, 3] }

  let(:args_2) { [4, 5, 6] }

  it 'Enqueue' do
    assert Resque.enqueue Jobs::BasicOne, *args_1
    assert Resque.enqueue Jobs::BasicOne, *args_2
    refute Resque.enqueue Jobs::BasicOne, *args_1

    expected_payloads = [args_1, args_2].map do |args|
      build_job_payload Jobs::BasicOne, args
    end

    assert_equal expected_payloads, queued_in(default_queue)
  end

  it 'Enqueue to' do
    assert Resque.enqueue_to :other_queue, Jobs::BasicOne, *args_1
    assert Resque.enqueue_to :other_queue, Jobs::BasicOne, *args_2
    refute Resque.enqueue_to :other_queue, Jobs::BasicOne, *args_1

    expected_payloads = [args_1, args_2].map do |args|
      build_job_payload Jobs::BasicOne, args
    end

    assert_equal expected_payloads, queued_in(:other_queue)
  end

  it 'Reserve' do
    Resque.enqueue Jobs::BasicOne, *args_1
    Resque.enqueue Jobs::BasicOne, *args_2

    job = Resque.reserve default_queue

    assert_equal build_job_payload(Jobs::BasicOne, args_1), job.payload
    assert_equal [build_job_payload(Jobs::BasicOne, args_2)], queued_in(default_queue)
  end

  it 'Dequeue with args' do
    Resque.enqueue Jobs::BasicOne, *args_1
    Resque.enqueue Jobs::BasicOne, *args_2

    assert_equal 1, Resque.dequeue(Jobs::BasicOne, *args_1)

    assert_equal [build_job_payload(Jobs::BasicOne, args_2)], queued_in(default_queue)
  end

  it 'Dequeue without args' do
    Resque.enqueue Jobs::BasicOne, *args_1
    Resque.enqueue Jobs::BasicOne, *args_2

    assert_equal 2, Resque.dequeue(Jobs::BasicOne)

    assert_empty queued_in(default_queue)
  end

  describe 'Unlock' do

    before do
      assert Resque.enqueue Jobs::BasicOne, *args_1
      refute Resque.enqueue Jobs::BasicOne, *args_1
    end

    it 'After reserve' do
      Resque.reserve default_queue

      assert Resque.enqueue Jobs::BasicOne, *args_1
    end

    it 'After dequeue' do
      Resque.dequeue Jobs::BasicOne, *args_1

      assert Resque.enqueue Jobs::BasicOne, *args_1
    end

    it 'After remove queue' do
      Resque.remove_queue default_queue

      assert Resque.enqueue Jobs::BasicOne, *args_1
    end

  end

end