import { useLoadScript, GoogleMap } from '@react-google-maps/api';
import { useMemo } from 'react';
import styles from '../styles/Home.module.css';
import React, { useState, useEffect } from 'react';
import axios from 'axios'

const Home = () => {
  const libraries = useMemo(() => ['places'], []);
  const mapCenter = useMemo(
    () => ({ lat: 36.9905, lng: -122.0584 }),
    []
  );
  const [test, setTest] = useState("wasgoody")
useEffect(()=>{
    axios({
      method: 'GET',
      url: `https://jsonplaceholder.typicode.com/todos/1`,
    })
});


  const { isLoaded } = useLoadScript({
    googleMapsApiKey: process.env.NEXT_PUBLIC_GOOGLE_MAPS_KEY,
    libraries: libraries,
  });

  if (!isLoaded) {
    return <p>Loading...</p>;
  }

  return (
    <div className={styles.homeWrapper}>
      <GoogleMap
        zoom={15}
        center={mapCenter}
        mapTypeId={google.maps.MapTypeId.ROADMAP}
        mapContainerStyle={{ width: '800px', height: '800px' }}
        onLoad={() => console.log('Map Component Loaded...')}
      />
    </div>
  );
};

export default Home;