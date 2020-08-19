// https://kntmr.hatenablog.com/entry/2018/02/28/200112

import axios from 'axios'

const debug = process.env.NODE_ENV !== 'production'

const onSuccess = (resp) => {
  if (debug) {
    console.log(' << ' + JSON.stringify(resp.data))
  }
  return Promise.resolve(resp.data)
}
const onError = () => {
  throw new Error('API error.')
}

export default {
  get: (url, params) => {
    if (debug) {
      console.log('GET ' + url + ' >> ' + JSON.stringify(params))
    }
    return axios.get(url, { params: params }).then(onSuccess).catch(onError)
  },
  post: (url, params) => {
    if (debug) {
      console.log('POST ' + url + ' >> ' + JSON.stringify(params))
    }
    return axios.post(url, params).then(onSuccess).catch(onError)
  },
  put: (url, params) => {
    if (debug) {
      console.log('PUT ' + url + ' >> ' + JSON.stringify(params))
    }
    return axios.put(url, params).then(onSuccess).catch(onError)
  },
  delete: (url, params) => {
    if (debug) {
      console.log('DELETE ' + url + ' >> ' + JSON.stringify(params))
    }
    return axios.delete(url, { params: params }).then(onSuccess).catch(onError)
  }
}
