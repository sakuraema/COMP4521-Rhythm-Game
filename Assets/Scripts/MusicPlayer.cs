using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Utilities;

public class MusicPlayer : MonoBehaviour
{
    public AudioSource musicSource;
    private Timer m_SpawnDelayTimer;
    private float m_Time;

    void Awake()
    {
        m_SpawnDelayTimer = new Timer(5f, PlayMusic);
        m_Time = -5f;
    }

    void FixedUpdate()
    {
        m_SpawnDelayTimer?.Tick(Time.fixedDeltaTime);
        //m_Time += Time.fixedDeltaTime;
        //if (m_Time > 30.0f)
            //StartCoroutine(AudioFade.StartFade(musicSource, 2.0f, 0.0f));
    }

    void PlayMusic()
    {
        musicSource.Play();
        m_SpawnDelayTimer = null;
    }
}
