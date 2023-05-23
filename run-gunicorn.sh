
if [[ -z "${OPENAI_API_KEY}" ]]; then
	echo "OPENAI_API_KEY is not set"
	exit 1
else
    echo "OPENAI_API_KEY is set"
    if ! openai api fine_tunes.list; then
        echo "Failed to run openai api fine_tunes.list"
        exit 1
    fi
fi

if [[ -z "${DD_API_KEY}" ]]; then
	echo "DD_API_KEY not set"
	exit 1
   else
	echo "DD_API_KEY is set"
fi



export DD_REMOTE_CONFIGURATION_ENABLED=false

DD_SERVICE=thegreatlibrary DD_ENV=dev DD_VERSION=0.1.0 \
	 ddtrace-run -p gunicorn -c gunicorn-cfg.py bakerydemo.openai:application  \
	 --keep-alive 3000 -t 3000 --graceful-timeout 3000
