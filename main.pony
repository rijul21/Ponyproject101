actor Main
  new create(env: Env) =>
    let args = env.args
    if args.size() != 3 then
      env.out.print("Usage: lukas <n> <k>")
      return
    end

    try
      let n = env.args(1)?
      let k = env.args(2)?

      // Converting
      // Converting string to integer
      let temp_float: F64 = n.f64()?
      let temp_int: U64 = temp_float.u64()

      let k_float: F64 = k.f64()?
      let k_int: U64 = k_float.u64()

      // Calling BOSS actor
      let boss = Boss(temp_int, k_int, env)
      boss.run()
    else
      env.out.print("!!!! Error occurred !!!!!")
    end

actor Boss
  let _n: U64
  let _k: U64
  let _env: Env
  var _workers: U64 = 0
  var _completed: U64 = 0
  var _found: Bool = false // Tracks whether an answer has been found
  let _work_unit_size: U64 = 5 // Can be adjusted for performance tuning

  new create(n: U64, k: U64, env: Env) =>
    _n = n
    _k = k
    _env = env

  // Start dividing the work among workers
  be run() =>
    let total_units: U64 = (_n / _work_unit_size) + 1
    _workers = total_units
    _env.out.print("Total workers: " + _workers.string())

    var i: U64 = 1
    var start_point: U64 = 1

    while i <= total_units do
      var end_point: U64 = (start_point + _work_unit_size) - 1
      if end_point > _n then
        end_point = _n
      end

      Worker(this, start_point, end_point, _k, _env, _n)
      start_point = end_point + 1
      i = i + 1
    end

  // Receive result from the worker (U64 instead of Array[U64])
  be result(found: U64) =>
    if (not _found) and (found != 0) then
      _env.out.print("ANSWER: " + found.string())
      _found = true // Mark that a result has been found to prevent further printing
    end

    _completed = _completed + 1
    if _completed == _workers then
      _env.out.print("All workers completed.")
    end

actor Worker
  let _boss: Boss
  let _start: U64
  let _end: U64
  let _k: U64
  let _env: Env
  let _n: U64

  new create(boss: Boss, start_point: U64, end_point: U64, k: U64, env: Env, n: U64) =>
    _boss = boss
    _start = start_point
    _end = end_point
    _k = k
    _env = env
    _n = n

    _process()

  // Processing each range of numbers to find the sequence
  fun _process() =>
    var i: U64 = _start
    while i <= _end do
      if i > _n then
        break
      end

      if _is_perfect_square_sum(i, _k) then
        // Push only the first valid result found, and stop processing
        _boss.result(i)
        return // Exit after the first valid result
      end
      i = i + 1
    end

    // If no valid result found, push 0
    _boss.result(0)

  // Check if the sum of squares from i to i+k-1 is a perfect square
  fun _is_perfect_square_sum(i: U64, k: U64): Bool =>
    var sum: U64 = 0
    var j: U64 = 0
    while j < k do
      sum = sum + ((i + j) * (i + j))
      j = j + 1
    end

    let sqrt_sum: U64 = _sqrt(sum)
    (sqrt_sum * sqrt_sum) == sum

  // Custom function to compute square root using Newton's method
  fun _sqrt(n: U64): U64 =>
    if n == 0 then
      0
    else
      var x: U64 = n
      var y: U64 = (x + (n / x)) / 2
      while y < x do
        x = y
        y = (x + (n / x)) / 2
      end
      x
    end
