# simple performance tests

nl() = print("\n")

function timeit(func, args...)
    nexpt = 5
    times = zeros(nexpt)

    for i=1:nexpt
        tic(); func(args...); times[i] = qtoc();
    end

    times = sort(times)
    print (times[1])
    nl()
    nl()
end

nl()

## recursive fib ##

fib(n) = n < 2 ? n : fib(n-1) + fib(n-2)

print("recursive fib(20): ")
f = fib(20)
assert(f == 6765)
timeit(fib, 20)

## parse int ##

print("parse_int: ")

function parseintperf(ignore)
    for i=1:1000
        global n
        n=bin("1111000011110000111100001111")
    end
    n
end

assert(parseintperf(true) == 252645135)
timeit(parseintperf, true)

## array constructors ##

print("ones: ")
o = ones(200,200)
assert(all(o==1))
timeit(ones, 200, 200)

## matmul and transpose ##

print("A * A': ")
matmul(o) = o * o'
assert(all(matmul(o)==200))
timeit(matmul, o)

## mandelbrot set: complex arithmetic and comprehensions ##

function mandel(z::Complex)
    n = 0
    c = z
    for n=0:79
        if abs(z)>2
            break
        end
        z = z^2+c
    end
    n
end

print("mandelbrot: ")
mandelperf(ignore) = [ mandel(Complex(r,i)) | r = -2.0:.1:0.5, i = -1.:.1:1. ]
assert(sum(mandelperf(true)) == 14791)
timeit(mandelperf, true)

## numeric vector quicksort ##

print("quicksort: ")
n = 5000
v = rand(n)
v = sort(v)
assert(issorted(v))
timeit(sort, v)

## slow pi series ##

function pisum(ignore)
    sum = 0.0
    for j=1:500
        sum = 0.0
        for k=1:10000
            sum += 1.0/(k*k)
        end
    end
    sum
end

print("pi sum: ")
s = pisum(true)
assert(abs(s-1.644834071848065) < 1e-12)
timeit(pisum, true)

## Random matrix statistics ##

function randmatstat(t)
    n=5
    v = zeros(t)
    w = zeros(t)
    for i=1:t
        a = randn(n, n)
        b = randn(n, n)
        c = randn(n, n)
        d = randn(n, n)
        P = [a, b, c, d]
        Q = [a, b;c, d]
        v[i] = trace((P'*P)^4)
        w[i] = trace((Q'*Q)^4)
    end
    return (std(v)/mean(v), std(w)/mean(w))
end

print("random matrix statistics: ")
(s1, s2) = randmatstat(1000)
assert(round(10*s1) > 6 && round(10*s1) < 8)
timeit(randmatstat, 1000)
