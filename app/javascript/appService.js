import axios from "axios";
import NProgress from "nprogress";

axios.interceptors.request.use((config) => {
  NProgress.start();
  return config;
});

axios.interceptors.response.use((response) => {
  NProgress.done();
  return response;
});

const appService = {
  getAllSubwayStops() {
    return doAjax("/api/subway_stops");
  },
  getSubwayArrivals(stopId) {
    return doAjax("/api/subway_stops/", stopId);
  },
  getAllBusStops() {
    return doAjax("/api/bus_stops");
  },
  getBusArrivals(stopId) {
    return doAjax("/api/bus_stops/", stopId);
  },
};

const doAjax = (url, param = "") => {
  return new Promise((resolve) => {
    axios
      .get(url + param)
      .then((response) => {
        resolve(response.data);
      })
      .catch((err) => {
        console.error(err);
      });
  });
};

export default appService;
