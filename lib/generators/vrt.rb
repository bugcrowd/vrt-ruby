# Pre-warm the in-memory store of these class instance vars when we launch the
# server. Prevents unnecessary file I/O per-request.
VRT.reload!
