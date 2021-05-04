using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicPlayer : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        musicSource.PlayDelayed(5.0f);
        m_Time = -5.0f;
    }

    // Update is called once per frame
    void Update()
    {
        m_Time += Time.deltaTime;
        if (m_Time > 30.0f)
            StartCoroutine(AudioFade.StartFade(musicSource, 2.0f, 0.0f));
    }
    
    public AudioSource musicSource;
    private float m_Time;
}
