
if [[ -z "${OPEN_API_KEY}" ]]; then
	    echo "OPEN_API_KEY is not set"
	    exit 1
    else
	    echo "OPEN_API_KEY is set"
fi

gunicorn -c gunicorn-cfg.py bakerydemo.openai:application &
