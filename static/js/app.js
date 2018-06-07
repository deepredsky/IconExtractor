const vm = new Vue({
  el: '#app',
  data: {
    url: null,
    results: [],
  },
  methods: {
    getIcons() {
      if (!this.url) {
        return
      }

      let data = new URLSearchParams()

      data.set('url', this.url)

      fetch('/', {
        method: 'POST',
        body: data,
        headers: new Headers({
          Accept: 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        }),
      })
        .then(res => res.json())
        .catch(() => (this.results = []))
        .then(icons => (this.results = icons))
    },
  },
})
