using JuMP
using SCIP

function getnum(pat, l)
	parse(Int, match(pat, l)[1])
end

function moron(ax, ay, bx, by, gx, gy)
	sol = missing
	for na in range(0, 100)
		for nb in range(0, 100)
			cost = na * 3 + nb * 1
			x = na * ax + nb * bx
			y = na * ay + nb * by
			if abs(gx - x) == 0
				if abs(gy - y) == 0
					if ismissing(sol) || sol > cost
						sol = cost
					end
				end
			end
		end
	end
	return sol
end

function solve(batch)
	ax = getnum(r"X\+([0-9]+)", batch[1])
	ay = getnum(r"Y\+([0-9]+)", batch[1])

	bx = getnum(r"X\+([0-9]+)", batch[2])
	by = getnum(r"Y\+([0-9]+)", batch[2])

	gx = getnum(r"X=([0-9]+)", batch[3]) + Rational(10000000000000)
	gy = getnum(r"Y=([0-9]+)", batch[3]) + Rational(10000000000000)

	# println(batch)
	# println([ax, ay, bx, by, gx, gy])

	# sol1 = solve_opt(ax, ay, bx, by, gx, gy)
	# sol2 = moron(ax, ay, bx, by, gx, gy)
	sol3 = matr(ax, ay, bx, by, gx, gy)
	# if !eqmissing(sol1, sol2) || !eqmissing(sol2, sol3)
		# println(sol1, " ", sol2, " ", sol3)
	# else
		# println("all ", sol1)
	# end
	return sol3
end

function eqmissing(a, b)
	if ismissing(a)
		return ismissing(b)
	end
	if ismissing(b)
		return ismissing(a)
	end
	return a == b
end

function solve_opt(ax, ay, bx, by, gx, gy)
	model = Model(SCIP.Optimizer)
	set_silent(model)

	@variable(model, na, Int)
	@variable(model, nb, Int)

	ac = 3
	bc = 1

	@constraint(model, na * ax + nb * bx == gx)
	@constraint(model, na * ay + nb * by == gy)

	@constraint(model, 0 <= na <= 100)
	@constraint(model, 0 <= nb <= 100)

	@objective(model, Min, na * ac + nb * bc)
	optimize!(model)

	if is_solved_and_feasible(model) && isinteger(value(na)) && isinteger(value(nb))
		sol = objective_value(model)
		# println(value(na), " ", value(nb))
		return Int(sol)
	else
		return missing
	end
end

function closeinteger(x)
	eps = 0.00001
	dx = mod(x, 1.0)
	return dx < eps || 1 - dx < eps
end

function matr(ax, ay, bx, by, gx, gy)
	A = [Rational(ax) Rational(bx) ; Rational(ay) Rational(by)]
	c = [Rational(gx) ; Rational(gy)]
	n = A \ c;
	if isinteger(n[1]) && isinteger(n[2]) # && 0 <= n[1] <= 100 && 0 <= n[2] <= 100
		round(3 * n[1] + 1 * n[2])
	else
		# println(n)
		missing
	end
end

function idiot()
	local total = 0
	local ls = readlines(ARGS[1])
	local batch = []
	for l in ls
		if l == ""
			sol = solve(batch)
			if !ismissing(sol)
				total += sol
			end
			batch = []
		else
			push!(batch, l)
		end
	end
	println(total)
end

idiot()
