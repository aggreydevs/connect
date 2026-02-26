# Known Limitations

## Media File Size

Tuwunel does not currently support streaming uploads or downloads. All media is buffered in RAM during transfer. Large files (e.g. over 100 MB) may cause excessive memory usage or timeouts on a shared VPS.

The `max_request_size` in the Tuwunel config is set to 20 MB (`20971520` bytes), which limits individual uploads.

Even with Cloudflare R2 mounted as the media volume via GeeseFS, file handling still passes through Tuwunel's web stack. R2 provides durable object storage but does not offload upload or download processing from the server. From a Tuwunel developer:

> "The web stack has little or no streaming, lots of buffering in RAM for everything. It's probably not very well tested at that scale and there could be other unknown bottlenecks."

Native S3 client support (uploading directly to object storage without going through Tuwunel) is tracked upstream: [Adding S3 client | port of #93 (Issue #21)](https://github.com/matrix-construct/tuwunel/issues/21).

### Current Mitigations

- `max_request_size` is set to 20 MB to prevent oversized uploads from exhausting server memory
- Media files are stored on Cloudflare R2 via GeeseFS, keeping VPS disk usage low (database only)
- For large file sharing, use external links instead of Matrix media uploads

### Possible Future Workarounds

- A custom Element Web client that detects large file uploads and sends them directly to R2, bypassing Tuwunel's media handling entirely. This has not been implemented.
- Native S3 support in Tuwunel (tracked in [Issue #21](https://github.com/matrix-construct/tuwunel/issues/21))
