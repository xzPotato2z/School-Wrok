from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/')
def index():
    # Execute all the worksheet questions and collect results
    results = {}
    
    # Question 1-2: Variable assignments
    x = 12
    y = 7.5
    results['q1'] = f"x = {x}"
    results['q2'] = f"y = {y}"
    
    # Question 3: Print x and y
    results['q3'] = f"x = {x}, y = {y}"
    
    # Question 4: Add x and y
    results['q4'] = f"{x} + {y} = {x + y}"
    
    # Question 5-6: Name variable
    name = "Minseo"
    results['q5'] = f"name = '{name}'"
    results['q6'] = f"Hello {name}"
    
    # Question 7: Convert x to float
    x_float = float(x)
    results['q7'] = f"float({x}) = {x_float} (type: {type(x_float).__name__})"
    
    # Question 8: Convert y to int
    y_int = int(y)
    results['q8'] = f"int({y}) = {y_int} (type: {type(y_int).__name__})"
    
    # Question 9: Convert 45 to string
    num_str = str(45)
    results['q9'] = f"str(45) = '{num_str}' (type: {type(num_str).__name__})"
    
    # Question 10: Convert '123' to int
    str_num = int('123')
    results['q10'] = f"int('123') = {str_num} (type: {type(str_num).__name__})"
    
    # Question 11: a and b operations
    a = 10
    b = 3
    results['q11'] = {
        'a': a,
        'b': b,
        'sum': a + b,
        'difference': a - b,
        'product': a * b
    }
    
    # Question 12: Division as float
    results['q12'] = f"{a} / {b} = {float(a) / float(b)}"
    
    # Question 13: Integer division
    results['q13'] = f"{a} // {b} = {a // b}"
    
    # Question 14: Modulo
    results['q14'] = f"{a} % {b} = {a % b}"
    
    # Question 15: Formatted string
    results['q15'] = f"The value of a is {a} and the value of b is {b}"
    
    # Question 16: Temperature conversion
    temperature = 72.5
    temperature_int = int(temperature)
    results['q16'] = {
        'float': temperature,
        'int': temperature_int
    }
    
    # Question 17: Average
    num1 = 15
    num2 = 25
    average = (num1 + num2) / 2
    results['q17'] = {
        'num1': num1,
        'num2': num2,
        'average': average
    }
    
    # Question 18: Area
    width = 5
    height = 8
    area = width * height
    results['q18'] = {
        'width': width,
        'height': height,
        'area': area
    }
    
    # Question 19: Total cost
    price = 4.99
    quantity = 3
    total_cost = price * quantity
    results['q19'] = {
        'price': price,
        'quantity': quantity,
        'total': total_cost
    }
    
    # Question 20: Age conversion
    age = '13'
    age_int = int(age)
    age_plus_5 = age_int + 5
    results['q20'] = {
        'original': age,
        'as_int': age_int,
        'plus_5': age_plus_5
    }
    
    return render_template('index.html', results=results)

@app.route('/extra', methods=['GET', 'POST'])
def extra_challenge():
    message = None
    if request.method == 'POST':
        user_name = request.form.get('name', '')
        user_age = request.form.get('age', '')
        if user_name and user_age:
            message = f"Hello, {user_name}! You are {user_age} years old."
    return render_template('extra.html', message=message)

if __name__ == '__main__':
    import os
    import sys
    # Get port from environment variable, command line, or default to 5000
    port = int(os.environ.get('FLASK_PORT', sys.argv[1] if len(sys.argv) > 1 else 5000))
    app.run(debug=True, host='127.0.0.1', port=port)

