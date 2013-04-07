#!/bin/bash -x

m=1

for file in ~/Music/Grim\ Fandango\ Soundtrack/*.oga; do
    d=$(avconv -i "$file" 2>&1 | sed -n "s/.*Duration: \([^:]*\):\([^:]*\):\([^,]*\).*/\2/p")
    if [[ $d -eq 0 ]]; then
        d=1
    fi
    curl http://localhost:3000/calls \
        -F "call[start(1i)]=2013" \
        -F "call[start(2i)]=4" \
        -F "call[start(3i)]=7" \
        -F "call[start(4i)]=08" \
        -F "call[start(5i)]=$m" \
        -F "call[end(1i)]=2013" \
        -F "call[end(2i)]=4" \
        -F "call[end(3i)]=7" \
        -F "call[end(4i)]=08" \
        -F "call[end(5i)]=$((m+d))" \
        -F "call[frequency]=771.75625" \
        -F "call[group_id]=1" \
        -F "audio[data]=@$file"
    m=$((m+1))
done
