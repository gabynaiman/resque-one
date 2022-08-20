module Jobs

  DEFAULT_QUEUE = :default

  class Basic

    @queue = DEFAULT_QUEUE

  end

  class Status

    include Resque::Plugins::Status

    @queue = DEFAULT_QUEUE

  end

  class BasicOne

    extend Resque::Plugins::One

    @queue = DEFAULT_QUEUE

  end

  class StatusOne

    include Resque::Plugins::Status
    extend Resque::Plugins::One

    @queue = DEFAULT_QUEUE

  end

end