# { sum += expr(); } # part 1

{ sum += mult(); } # part 2

END { print sum; }

function token(   tok) {
	if (previous) {
		tok = previous;
		previous = "";
	} else if ($0 == "") {
		return "";
	} else {
		sub(/^ */, ""); # remove spaces
		if (!match($0, /[()+*]|[0-9]+/)) {
			print "Invalid token at:", $0;
			exit;
		}
		tok = substr($0, RSTART, RLENGTH);
		$0 = substr($0, RSTART + RLENGTH);
	}
	return tok;
}

function putback(tok) {
	if (previous) {
		print "Has already put back", previous;
		exit;
	}
	previous = tok;
}

function expr(   val, tok) { # operand + expr | operand * expr
	val = operand();
	while (1) {
		tok = token();
		if (tok == "+") {
			val += operand();
		} else if (tok == "*") {
			val *= operand();
		} else {
			break;
		}
	}
	putback(tok); # read one too far
	return val;
}

function mult(   val, tok) { # add * mult | add
	val = add();
	while (1) {
		tok = token();
		if (tok == "*") {
			val *= add();
		} else {
			break;
		}
	}
	putback(tok); # read one too far
	print "read mult", val;
	return val;
}

function add(   val, tok) { # operand + add | operand
	val = operand();
	while (1) {
		tok = token();
		if (tok == "+") {
			val += operand();
		} else {
			break;
		}
	}
	putback(tok); # read one too far
	print "read add", val;
	return val;
}

function operand(   tok, ex) { # ( expr ) | number
	tok = token();
	if (tok == "(") {
		# ex = expr(); # part 1
		ex = mult(); # part 2
		if (token() != ")") {
			print "Expected ) before", $0;
			exit;
		}
		print "read paren", ex;
		return ex;
	} else {
		if (tok !~ /^[0-9]+$/) {
			print "Expected number, got", tok;
			exit;
		}
		print "read number", tok;
		return tok + 0;
	}
}
