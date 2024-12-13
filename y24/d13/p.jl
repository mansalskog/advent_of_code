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

	gx = getnum(r"X=([0-9]+)", batch[3])
	gy = getnum(r"Y=([0-9]+)", batch[3])

	# println(batch)
	# println([ax, ay, bx, by, gx, gy])

	sol1 = solve_opt(ax, ay, bx, by, gx, gy)
	sol2 = moron(ax, ay, bx, by, gx, gy)
	if ismissing(sol1) || ismissing(sol2) || sol1 != sol2
		# println(sol1, " ", sol2)
	end
	return sol2
end

function solve_opt(ax, ay, bx, by, gx, gy)
	model = Model(SCIP.Optimizer)
	set_silent(model)

	@variable(model, na, Int)
	@variable(model, nb, Int)

	ac = 3
	bc = 1

	@constraint(model, (na * ax + nb * bx - gx) <= 0.1)
	@constraint(model, (na * ay + nb * by - gy) <= 0.1)
	@constraint(model, (na * ax + nb * bx - gx) >= -0.1)
	@constraint(model, (na * ay + nb * by - gy) >= -0.1)

	@constraint(model, 0 <= na <= 100)
	@constraint(model, 0 <= nb <= 100)

	@objective(model, Min, na * ac + nb * bc)
	optimize!(model)

	if is_solved_and_feasible(model)
		sol = objective_value(model)
		# println(value(na), " ", value(nb))
		return Int(sol)
	else
		return missing
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
