#undef SLIGHT_SSL_CTX
#undef SLIGHT_SSL_CTX_new
#undef SLIGHT_SSL_client_method
#undef SLIGHT_SSL_CTX_set_version
#undef SLIGHT_SSL_CTX_free
#undef SLIGHT_SSL_set_usercontext
#undef SLIGHT_SSL_set_fd
#undef SLIGHT_SSL_connect
#undef SLIGHT_SSL_get_error
#undef SLIGHT_SSL_read
#undef SLIGHT_SSL_pending
#undef SLIGHT_SSL_want_write
#undef SLIGHT_SSL_write
#undef SLIGHT_SSL_CTX_set_performance_cb

#undef SSL_ERROR_WANT_WRITE
#undef SSL_ERROR_WANT_READ
#undef SLIGHT_SSL
#undef SLIGHT_SSL_PERFORMANCE_DATA
#undef SLIGHT_SSL_new
#undef SLIGHT_SSL_free
#undef SLIGHT_SSL_CTX_set_cert_cb
#undef SLIGHT_SSL_CTX_set_pubkey_cb
#undef SSL_READ_END_ERR
#undef SLIGHT_SSL_is_write_block

#define SLIGHT_SSL_client_method SLIGHT_SSL_method

//#undef ERR_READ_END
//#undef ERR_WRITE_END
