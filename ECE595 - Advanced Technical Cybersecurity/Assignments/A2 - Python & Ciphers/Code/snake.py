def function():
    old = 'snakety snake snake'

    new = ''
    for c in range(len(old)):
        if not c % 2:
            new = new + old[c].upper()
        else:
            new = new + old[c].lower()
    print(new.replace(" ", "_"))

if __name__ == '__main__':
        function()