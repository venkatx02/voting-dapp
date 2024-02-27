import React, {useState, useEffect, useContext} from 'react';
import Image from 'next/image';
import Countdown from 'react-countdown';
import { VotingContext } from '@/context/voter';


const Home = () => {
  const {votingTitle} = useContext(VotingContext);
  return (
    <div>
      {votingTitle}
    </div>
  )
}

export default Home
