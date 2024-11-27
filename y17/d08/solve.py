with open('input.txt') as _f:
    _rs = set()
    _M = 0
    for _l in _f:
        _l = _l[:-1].replace('inc', '+=').replace('dec', '-=') + ' else 0'
        _r0 = _l.split(' ')[0]
        if _r0 not in vars():
            exec(_r0 + ' = 0')
            _rs.add(_r0)
        _r1 = _l.split(' ')[4]
        if _r1 not in vars():
            exec(_r1 + ' = 0')
            _rs.add(_r1)
        exec(_l)
        _M = max(_M, max(eval(r) for r in _rs))
    print(max(eval(r) for r in _rs))
    print(_M)
