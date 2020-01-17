# Author(s): Kenneth Foo, Brayden Tang, Brendon Campbell
# Date: January 17, 2020 

"""This script downloads and extracts a .zip file from a specified 
web URL to a given file path provided by the user. This script assumes that it will be run
in the root of the project directory.

Usage: data-download.py <url_link> --file_path=<file_path>

Options:
<url_link>                  A url link to the .zip file.
--file_path=<file_path>     A relative file path to which the .zip file will be downloaded.
"""

import requests, zipfile, io
from docopt import docopt


opt = docopt(__doc__)


def main(url_link, file_path):
    """ 
    This function downloads data files from a .zip file and stores them in a given file
    path.
    
    Parameters
    ----------
    url_link: str
        A str that gives a web URL to a .zip file to be downloaded.
    
    file_path: str
        A str that provides an absolute file path in which the extracted .zip file will
        be stored.
    
    Returns
    ---------
    NA

    """
    r = requests.get(url_link)
    z = zipfile.ZipFile(io.BytesIO(r.content))
    
    # Assume run cmd line from project repo root. 
    z.extractall("./" + file_path)
    print("File downloaded to:", file_path)
    return 



# Pull in the data

main(url_link=opt['<url_link>'], file_path=opt['--file_path'])
