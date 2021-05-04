using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicPlayer : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        musicSource.PlayDelayed(5.0f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    public AudioSource musicSource;
}
