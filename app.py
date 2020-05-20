import os
from flask import Flask, redirect, url_for, request, render_template
from tenable.cs import ContainerSecurity

app = Flask(__name__)

cs = ContainerSecurity(os.environ['TENABLE_ACCESS_KEY'],os.environ['TENABLE_SECRET_KEY'])

@app.route('/')
def images():
    _items = cs.images.list()
    items = [item for item in _items]

    return render_template('index.html', items=items)


@app.route('/image/<repository>/<image>/<tag>')
def image_detail(repository,image,tag):

    item = cs.images.details(repository,image,tag)

    return render_template('image.html', item=item)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)