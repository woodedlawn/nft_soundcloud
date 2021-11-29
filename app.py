# import necessary libraries
import os
import json

from dotenv import load_dotenv
load_dotenv()

from flask import (
    Flask,
    # flash,
    render_template,
    # jsonify,
    request,
    redirect,
    session,
    url_for)
from werkzeug.utils import secure_filename

from pinata import pin_file_to_ipfs, pin_json_to_ipfs, convert_data_to_json

#################################################
# Flask Setup
#################################################
app = Flask(__name__)
APP_ROOT = os.path.dirname(os.path.abspath(__file__))
app.config['UPLOAD_FOLDER'] = os.path.join(APP_ROOT, 'static/uploads')
app.config.update(SECRET_KEY = os.urandom(24))
if app.debug == True:
    app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0


image_file_hash = 'QmVMjWBk7ea2bdaMM6C8gT2C9ngfWtLXhFEXM5DTbmXmwQ'

site_config = {
    "sitename": "NFT SoundChain",
    "sitelogo": "/static/images/rawasy_logo.png",
    "page_title": "NFT SoundChain",
    "head_links": [
        {
            "active": "active",
            "title": "Create",
            "link": "/create"
        },
        {
            "active": "active",
            "title": "Discover",
            "link": "/discover"
        },
        {
            "active": "active",
            "title": "About",
            "link": "/about",
        }
    ],
    "smart_contract_address": os.getenv("SMART_CONTRACT_ADDRESS"),
    "smart_contract_abi": os.getenv("SMART_CONTRACT_ABI"),
}
page_config = {
}

# create route that renders index.html template
@app.route("/")
def home():
    page_config = {
        "title": "NFT SoundChain",
        "details": "A community for creating and sharing music NFTs",
        "content": "Here we describe what we do in details",
    }
    return render_template("index.html", site_config=site_config, page_config=page_config)


ALLOWED_EXTENSIONS = {'wav', 'mp3'}
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS



@app.route("/create", methods=['GET', 'POST'])
def create():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'nft_file' not in request.files:
            # flash('No file part')
            return redirect(request.url)
        file = request.files['nft_file']
        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename == '':
            # flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            session['filename'] = filename
            session['name'] = request.form['nft_name']
            session['description'] = request.form['nft_description']
            session['instrument'] = request.form['nft_instrument']
            session['genre'] = request.form['nft_genre']
            return redirect(url_for('create_nft'))
    else:
        page_config = {
            "title": "Create",
            "details": "Upload your samples, riffs and tracks to and generate your NFTs (gas fees will apply)",
            "content": "Here we describe what we do in details",
        }
        return render_template("create.html", site_config=site_config, page_config=page_config)



@app.route("/create_nft")
def create_nft():
    filename = session['filename']
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    print(file_path)

    with open(file_path, 'rb') as f:
        file = f.read()

        # Pin the file to IPFS with Pinata
        ipfs_file_hash = pin_file_to_ipfs(file)

        # Build a token metadata file for the sound
        token_json = {
            "name": session['name'],
            "description": session['description'],
            "image": f"ipfs://{image_file_hash}",
            "animation_url": f"ipfs://{ipfs_file_hash}",
            "instrument": session['instrument'],
            "genre": session['genre'],
        }
        json_data = convert_data_to_json(token_json)

        # Pin the json to IPFS with Pinata
        token_ipfs_hash = pin_json_to_ipfs(json_data)
        token_ipfs_gateway_url = f"https://gateway.pinata.cloud/ipfs/{token_ipfs_hash}"

    token_config = {
        "name": session['name'],
        "instrument": session['instrument'],
        "genre": session['genre'],
        "tokenUri": f"ipfs://{token_ipfs_hash}"
    }

    page_config = {
        "title": "Create your NFT!",
        "details": "Create an NFT of your audio on the Ethereum blockchain!",
        "token_ipfs_hash": token_ipfs_hash,
        "token_ipfs_gateway_url": token_ipfs_gateway_url,
        "token_config": json.dumps(token_config),
    }
    
    return render_template("create_nft.html", site_config=site_config, page_config=page_config)



@app.route("/discover")
def discover():
    page_config = {
        "title": "Discover",
        "details": "Browse community music NFTs. Find some inspiration and bid on samples to include in yout project or propose a royalty agreement to the owner.",
        "content": "Here we describe what we do in details",
    }
    return render_template("discover.html", site_config=site_config, page_config=page_config)


if __name__ == "__main__":
    app.run(debug=True)
