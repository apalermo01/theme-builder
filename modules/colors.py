import logging
from typing import Dict, Any, List
import os
import json
import subprocess
import matplotlib.pyplot as plt 
import json

logger = logging.getLogger(__name__)

def parse_colors(
        config: Dict, **kwargs
) -> Dict:
    """Function to parse the colorscheme
    
    Arguments to config:

    - method: "manual" 

    TODO:
    add option for pywal
    """

    allowed_methods: List[str] = ['manual']
    method: str = config['colors'].get('method', 'manual')

    if method not in allowed_methods:
        raise ValueError("method not supported. Expected one of: " +\
                         allowed_methods + f" but got {method}")

    return config
